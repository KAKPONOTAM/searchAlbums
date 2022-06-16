import UIKit

class LoginViewController: UIViewController {
    private var scrollViewBottomAnchor: NSLayoutConstraint?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let containerView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .extraLight)
        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Titles.getTitle(from: .loginTextFieldPlaceholder)
        textField.layer.cornerRadius = 5
        textField.delegate = self
        textField.layer.borderWidth = 1
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Titles.getTitle(from: .passwordTextFieldPlaceholder)
        textField.layer.cornerRadius = 5
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.layer.borderWidth = 1
        return textField
    }()
    
    private lazy var completeLoginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Titles.getTitle(from: .authorizationButtonTitle), for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(completeLoginButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setupConstraints()
        registerForKeyboardNotifications()
        hideKeyBoardRecognizer()
    }
    
    private func addSubview() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.contentView.addSubview(loginTextField)
        containerView.contentView.addSubview(passwordTextField)
        containerView.contentView.addSubview(completeLoginButton)
    }
    
    private func setupConstraints() {
        let offset: CGFloat = 50
        let height: CGFloat = 30
        scrollViewBottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollViewBottomAnchor ?? scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loginTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loginTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -offset),
            loginTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: offset / 5),
            loginTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -offset / 5),
            loginTextField.heightAnchor.constraint(equalToConstant: height)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: offset / 5),
            passwordTextField.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: loginTextField.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            completeLoginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: offset),
            completeLoginButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            completeLoginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            completeLoginButton.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func completeLoginButtonTapped() {
        guard let userData = UserDataManager.receiveResults() else { return }
        if loginTextField.text == userData.email && passwordTextField.text == userData.password {
            let searchAlbumViewController = SearchAlbumsViewController()
            let navigationController = UINavigationController(rootViewController: searchAlbumViewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
            loginTextField.text = nil
            passwordTextField.text = nil
        } else {
            createAndPresentAlert(title: Titles.getTitle(from: .cantFindUserAlertTitle), message: nil, handlerForOkButton: nil, handlerForCancel: nil, titleForCancel: nil)
        }
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            scrollViewBottomAnchor?.isActive = false
            
            scrollViewBottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardScreenEndFrame.height - 15)
            scrollViewBottomAnchor?.isActive = true
            
        } else if notification.name == UIResponder.keyboardWillHideNotification {
            scrollViewBottomAnchor?.isActive = false
            
            scrollViewBottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            scrollViewBottomAnchor?.isActive = true
        }
        
        view.needsUpdateConstraints()
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideKeyBoardRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        containerView.addGestureRecognizer(recognizer)
    }
    
    @objc private func hideKeyBoard() {
        view.endEditing(true)
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case loginTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            break
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return true
    }
}

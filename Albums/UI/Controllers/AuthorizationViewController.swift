import UIKit
class AuthorizationViewController: UIViewController {
    private let greetingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = ModuleImages.getImage(by: .welcomeImage)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Titles.getTitle(from: .signUpTitle), for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Titles.getTitle(from: .loginButtonTitle), for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setupConstraints()
    }
    
    private func addSubview() {
        view.addSubview(greetingImageView)
        view.addSubview(signUpButton)
        view.addSubview(loginButton)
    }
    
    private func setupConstraints() {
        let offset: CGFloat = 50
        NSLayoutConstraint.activate([
            greetingImageView.topAnchor.constraint(equalTo: view.topAnchor),
            greetingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            greetingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            greetingImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 2)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
            signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -offset / 2)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -offset / 5),
            loginButton.leadingAnchor.constraint(equalTo: signUpButton.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: signUpButton.trailingAnchor)
        ])
    }
    
    @objc private func signUpButtonPressed() {
        let registrationViewController = RegistrationViewController()
        navigationController?.pushViewController(registrationViewController, animated: true)
    }
    
    @objc private func loginButtonPressed() {
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(loginViewController, animated: true)
    }
}



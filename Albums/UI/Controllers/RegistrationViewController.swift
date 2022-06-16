import UIKit

class RegistrationViewController: UIViewController {
    fileprivate var selectedDate: String? {
        didSet {
            registrationTableView.reloadData()
        }
    }
    
    fileprivate var userInfo: [String: String] = [:]
    
    private lazy var registrationTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RegistrationTableViewCell.self, forCellReuseIdentifier: RegistrationTableViewCell.identifier)
        tableView.register(FinishRegistrationTableViewCell.self, forCellReuseIdentifier: FinishRegistrationTableViewCell.identifier)
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setupConstraints()
        registerForKeyBoardNotifications()
        hideKeyBoardRecognizer()
    }
    
    private func addSubview() {
        view.addSubview(registrationTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            registrationTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            registrationTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            registrationTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            registrationTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func hideKeyBoardRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        registrationTableView.addGestureRecognizer(recognizer)
    }
    
    @objc private func hideKeyBoard() {
        view.endEditing(true)
    }
    
    private func registerForKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            registrationTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height , right: 0)
        }
    }
    
    @objc  func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            UIView.animate(withDuration: animationDuration) {
                self.registrationTableView.contentInset = .zero
            }
        }
    }
}

extension RegistrationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RegistrationCellType.getSectionAmounts()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.defaultHeightForRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = RegistrationCellType.getRow(from: indexPath.row)
        
        switch cellType {
        case .finishRegistrationButton:
            guard let registrationCell = tableView.dequeueReusableCell(withIdentifier: FinishRegistrationTableViewCell.identifier, for: indexPath) as? FinishRegistrationTableViewCell else { return UITableViewCell() }
            registrationCell.delegate = self
            return registrationCell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationTableViewCell.identifier, for: indexPath) as? RegistrationTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configure(type: cellType, selectedDate: selectedDate, registrationRowText: userInfo[cellType.rawValue])
            
            return cell
        }
    }
}

extension RegistrationViewController: RegistrationTableViewCellDelegate {
    func textFieldChangedRow(type: String, info: String) {
        userInfo[type] = info
    }
    
    func calendarButtonTapped() {
        let calendarViewController = CalendarViewController()
        calendarViewController.delegate = self
        present(calendarViewController, animated: true)
    }
}

extension RegistrationViewController: CalendarViewControllerDelegate {
    func dateDidSelect(selectedDate: String) {
        self.selectedDate = selectedDate
    }
}

extension RegistrationViewController: FinishRegistrationTableViewCellDelegate {
    func registrationButtonTapped() {
        view.endEditing(true)
        selectedDate != nil ? userInfo[RegistrationCellType.age.rawValue] = selectedDate : print()
        
        guard let password = userInfo[RegistrationCellType.password.rawValue],
              let phoneNumber = userInfo[RegistrationCellType.phoneNumber.rawValue],
              let email = userInfo[RegistrationCellType.email.rawValue],
              let name = userInfo[RegistrationCellType.name.rawValue],
              let surname = userInfo[RegistrationCellType.surname.rawValue],
              let age = userInfo[RegistrationCellType.age.rawValue] else { return }
        
        if let age = Int(age), age < 18 {
            createAndPresentAlert(title: Titles.getTitle(from: .notValidAge), message: nil, handlerForOkButton: nil, handlerForCancel: nil, titleForCancel: nil)
        }
        
        if  phoneNumber.count < 17 || phoneNumber.count > 18  {
            createAndPresentAlert(title: Titles.getTitle(from: .notValidPhoneNumberAlertTitle), message: nil, handlerForOkButton: nil, handlerForCancel: nil, titleForCancel: nil)
        }
        
        ValidationTypes.isValid(validationTypes: .emailValidation, registrationRowValue: email) ? print() : createAndPresentAlert(title: Titles.getTitle(from: .notValidEmailAlertTitle), message: nil, handlerForOkButton: nil, handlerForCancel: nil, titleForCancel: nil)
        
        if !ValidationTypes.isValid(validationTypes: .passwordValidation, registrationRowValue: password) {
            createAndPresentAlert(title: Titles.getTitle(from: .notValidPasswordAlertTitle), message: nil, handlerForOkButton: nil, handlerForCancel: nil, titleForCancel: nil)
        }
        
        let userData = UserData(age: age, email: email, name: name, password: password, surname: surname, phoneNumber: phoneNumber)
        
        UserDataManager.saveResults(userData: userData)
        
        createAndPresentAlert(title: Titles.getTitle(from: .successRegistrationAlertTitle), message: Titles.getTitle(from: .successRegistrationAlertMessage), handlerForOkButton: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }, handlerForCancel: nil, titleForCancel: nil)
    }
}



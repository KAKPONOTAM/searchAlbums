import UIKit
protocol RegistrationTableViewCellDelegate: AnyObject {
    func calendarButtonTapped()
    func textFieldChangedRow(type: String, info: String)
}

class RegistrationTableViewCell: UITableViewCell {
    weak var delegate: RegistrationTableViewCellDelegate?
    private let regex = try? NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    private var type: RegistrationCellType?
    private var userInfo: [String: String] = [:]
    
    lazy var registrationTypeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if type == .age {
            accessoryView = nil
        }
        
        registrationTypeTextField.text = nil
    }
    
    private func addSubview() {
        contentView.addSubview(registrationTypeTextField)
    }
    
    private func createCalendarButton() -> UIView {
        let calendarButton = UIButton(type: .custom)
        calendarButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        calendarButton.setImage(ModuleImages.getImage(by: .calendarImage), for: .normal)
        calendarButton.contentMode = .scaleAspectFit
        calendarButton.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
        return calendarButton
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            registrationTypeTextField.topAnchor.constraint(equalTo: contentView.topAnchor),
            registrationTypeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            registrationTypeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            registrationTypeTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func formatePhoneNumber(phoneNumber: String, shouldDeleteLastDigit: Bool) -> String {
        guard !(shouldDeleteLastDigit && phoneNumber.count <= 2) else { return "+" }
        guard let regex = regex else { return "" }
        
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
        
        if number.count > 11 {
            let maxIndex = number.index(number.startIndex, offsetBy: 11)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        if shouldDeleteLastDigit {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
        
        if number.count < 7 {
            let pattern = "(\\d)(\\d{3})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
        } else {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
        }
        
        if number.first == "7" {
            return "+" + number
        } else {
            return number
        }
    }
    
    
    func configure(type: RegistrationCellType, selectedDate: String?, registrationRowText: String?) {
        registrationTypeTextField.placeholder = type.title
        registrationTypeTextField.text = registrationRowText
        self.type = type
        
        switch type {
        case .name:
            registrationTypeTextField.keyboardType = .asciiCapable
        case .surname:
            registrationTypeTextField.keyboardType = .asciiCapable
        case .age:
            registrationTypeTextField.keyboardType = .numberPad
            accessoryView = createCalendarButton()
            registrationTypeTextField.text = selectedDate
        case .phoneNumber:
            registrationTypeTextField.keyboardType = .numberPad
        case .email:
            registrationTypeTextField.keyboardType = .asciiCapable
        default:
           accessoryView = nil
        }
    }
    
    @objc private func calendarButtonTapped() {
        delegate?.calendarButtonTapped()
    }
}

extension RegistrationTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if type == .phoneNumber {
            let fullString = (textField.text ?? "") + string
            textField.text = formatePhoneNumber(phoneNumber: fullString, shouldDeleteLastDigit: range.length == 1)
            return false
            
        } else if type == .age {
            let maxLength = 3
            guard let currentString = registrationTypeTextField.text as? NSString else { return true }
            let newString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            return newString.length <= maxLength
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let type = type,
              let registrationTextFieldText = registrationTypeTextField.text else { return }
        
        
        
        delegate?.textFieldChangedRow(type: type.rawValue, info: registrationTextFieldText)
    }
}

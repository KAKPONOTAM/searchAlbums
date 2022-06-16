import Foundation

enum RegistrationCellType: String, CaseIterable {
    case name
    case surname
    case age
    case phoneNumber
    case email
    case password
    case finishRegistrationButton
    
    static func getSectionAmounts() -> Int {
        return allCases.count
    }
    
    static func getRow(from index: Int) -> Self {
        return allCases[index]
    }
    
    var title: String {
        switch self {
        case .name:
            return " Введите имя"
        case .surname:
            return " Введите фамилию"
        case .age:
            return " Введите возраст"
        case .phoneNumber:
            return " Введите номер телефона"
        case .email:
            return " Введите e - mail"
        case .password:
            return " Введите пароль"
        case .finishRegistrationButton:
            return "Зарегестрироваться"
        }
    }
}

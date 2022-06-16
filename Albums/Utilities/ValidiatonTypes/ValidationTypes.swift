import Foundation

enum ValidationTypes {
    case passwordValidation
    case emailValidation
    
    var regex: String {
        switch self {
        case .passwordValidation:
            return "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$"
           
        case .emailValidation:
            return "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
        }
    }
    
    static func isValid(validationTypes: ValidationTypes, registrationRowValue: String) -> Bool {
        let validationRegex = validationTypes.regex
        let validationPredicate = NSPredicate(format: "SELF MATCHES %@", validationRegex)
        
        return validationPredicate.evaluate(with: registrationRowValue)
    }
}

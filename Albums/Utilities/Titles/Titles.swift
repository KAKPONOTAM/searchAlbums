import Foundation

enum Titles {
    case loginButtonTitle
    case signUpTitle
    case finishRegistrationButtonTitle
    case authorizationButtonTitle
    case searchAlbumsTextFieldPlaceholder
    case searchViewControllerNavigationBarTitle
    case successRegistrationAlertTitle
    case successRegistrationAlertMessage
    case loginTextFieldPlaceholder
    case passwordTextFieldPlaceholder
    case okActionTitle
    case notValidPhoneNumberAlertTitle
    case notValidEmailAlertTitle
    case notValidPasswordAlertTitle
    case notValidAge
    case cantFindUserAlertTitle
    case cancelActionTitle
    case signOutButtonTitle
    case signOutAlertTitle
    
    var title: String {
        switch self {
        case .loginButtonTitle:
            return " Login"
        case .signUpTitle:
            return "Sign up"
        case .finishRegistrationButtonTitle:
            return "Зарегистрироваться"
        case .authorizationButtonTitle:
            return "Войти"
        case .searchAlbumsTextFieldPlaceholder:
            return " Поиск"
        case .searchViewControllerNavigationBarTitle:
            return "Search"
        case .successRegistrationAlertTitle:
            return "Поздравляю"
        case .successRegistrationAlertMessage:
            return "Аккаунт успешно создан. Вернитесь на стартовый экран и войдите в аккаунт"
        case .okActionTitle:
            return "OK"
        case .loginTextFieldPlaceholder:
            return " Логин"
        case .passwordTextFieldPlaceholder:
            return " Пароль"
        case .notValidPhoneNumberAlertTitle:
            return "Введите валидный номер телефона"
        case .notValidEmailAlertTitle:
            return "Введите валидный email"
        case .notValidPasswordAlertTitle:
            return "Пароль должен содержать минимум 6 символов, хотя бы одну цифру, букву нижнего регистра и букву верхнего регистра"
        case .notValidAge:
            return "Вам должно быть не меньше 18"
        case .cantFindUserAlertTitle:
            return "Пользователь не найден"
        case .cancelActionTitle:
            return "Cancel"
        case .signOutButtonTitle:
            return "Sign out"
        case .signOutAlertTitle:
            return "Вы уверены что хотите выйти из аккаунта ?"
        }
    }
    
    static func getTitle(from titles: Titles) -> String {
        return titles.title
    }
}

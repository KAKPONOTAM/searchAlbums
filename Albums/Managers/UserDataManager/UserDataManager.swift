import Foundation

class UserDataManager {
    class func saveResults(userData: UserData) {
        UserDefaults.standard.setValue(encodable: userData, forKey: "key")
    }
    
    class func receiveResults() -> UserData? {
        guard let models = UserDefaults.standard.loadValue(UserData.self, forKey: "key") else { return nil }
        return models
    }
    
}

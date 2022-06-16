import Foundation
import UIKit

enum ModuleImages: CaseIterable {
    case welcomeImage
    case calendarImage
    case dismissImage
    case profileImage
    case signOutImage
    
    
    var titleImage: UIImage? {
        switch self {
        case .welcomeImage:
            return UIImage(named: "welcome")
        case .calendarImage:
            return UIImage(named: "calendar")
        case .dismissImage:
            return UIImage(systemName: "arrow.left")
        case .profileImage:
            return UIImage(systemName: "person.crop.circle")
        case .signOutImage:
            return UIImage(named: "signout")
        }
    }
    
    static func getImage(by moduleImage: ModuleImages) -> UIImage? {
        return moduleImage.titleImage
    }
}


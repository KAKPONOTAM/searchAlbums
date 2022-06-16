import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        var rootViewController: UIViewController
        if let _ = UserDataManager.receiveResults() {
            rootViewController = SearchAlbumsViewController()
        } else {
            rootViewController = AuthorizationViewController()
        }
        
        let navigationViewController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        return true
    }
}


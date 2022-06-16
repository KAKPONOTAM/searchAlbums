import Foundation
import UIKit

extension UIViewController {
    struct Constants {
        static let defaultHeightForRow: CGFloat = 60
        static let defaultHeightForSearchRow: CGFloat = 170
        static let defaultHeightForAlbumDetailedDataRow: CGFloat = 20
    }
    
    func createAndPresentAlert(title: String?, message: String?, handlerForOkButton: ((UIAlertAction) -> ())?, handlerForCancel: ((UIAlertAction) -> ())?, titleForCancel: String? ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Titles.getTitle(from: .okActionTitle), style: .default, handler: handlerForOkButton)
        let cancelAction = UIAlertAction(title: Titles.getTitle(from: .cancelActionTitle), style: .cancel, handler: handlerForCancel)
        
        if titleForCancel != nil {
            alert.addAction(cancelAction)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

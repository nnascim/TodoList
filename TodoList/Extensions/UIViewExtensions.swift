import UIKit

extension UIView {
    
    static func buildNib<T: UIView>() -> T {
        let nibName = String(describing: T.self)
        
        guard let nibView = Bundle(for: T.self).loadNibNamed(nibName, owner: self)?.first as? T else {
            assertionFailure("Unable to load a nibView for \(nibName)")
            return T()
        }
        
        return nibView
    }
}

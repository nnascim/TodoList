import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(cellType: T.Type) {
        let reuseIdentifier = String(describing: T.self)
        let nib = UINib(nibName: reuseIdentifier, bundle: Bundle(for: T.self))
        
        register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let reuseIdentifier = String(describing: T.self)
        
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
            assertionFailure("Unable to dequeue a cell for \(reuseIdentifier)")
            return T()
        }
        
        return cell
    }
}

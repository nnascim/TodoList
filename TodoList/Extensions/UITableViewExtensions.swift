import UIKit

extension UITableView {
    
    /// Registers a nib object containing a cell with the table view. Use this function to avoid creating a reuse ID.
    ///
    /// - Parameters:- cellType: Object whose type will be used as a name for the reuseIdentifier and bundle.
    func register<T: UITableViewCell>(cellType: T.Type) {
        let reuseIdentifier = String(describing: T.self)
        let nib = UINib(nibName: reuseIdentifier, bundle: Bundle(for: T.self))
        
        register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
    
    /// Returns a reusable table-view cell object and adds it to the table. Use this function to avoid creating a reuseIdentifier.
    ///
    /// - Parameter indexPath: The index path specifying the location of the cell. The data source receives this information when
    ///     it is asked for the cell and should just pass it along. This method uses the index path to
    ///     perform additional configuration based on the cell’s position in the table view.
    ///
    /// - Returns: A generic UITableViewCell with the associated "reuseIdentifier". This method always returns a valid cell.
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let reuseIdentifier = String(describing: T.self)
        
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
            assertionFailure("Unable to dequeue a cell for \(reuseIdentifier)")
            return T()
        }
        return cell
    }
}

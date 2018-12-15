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
    
    // Gio - I want to add the ability to display custom actions when the user swipes a table row,
    // specifically the ability to edit.  The example code below is from
    // https://useyourloaf.com/blog/table-swipe-actions/ where they give the ability to
    // 'favorite' an item.  We'll change this to Edit, but just for starters, do I even have this code in the right place?  And if so, it seems we need to replace dataSource? with something else, but I can't figure out what that it.  Thoughts?
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        ->   UISwipeActionsConfiguration? {
            
            // Get current state from data source
            guard let favorite = dataSource?.favorite(at: indexPath) else {
                return nil
            }
            
            let title = favorite ?
                NSLocalizedString("Unfavorite", comment: "Unfavorite") :
                NSLocalizedString("Favorite", comment: "Favorite")
            
            let action = UIContextualAction(style: .normal, title: title,
                                            handler: { (action, view, completionHandler) in
                                                // Update data source when user taps action
                                                self.dataSource?.setFavorite(!favorite, at: indexPath)
                                                completionHandler(true)
            })
            
            action.image = UIImage(named: "heart")
            action.backgroundColor = favorite ? .red : .green
            let configuration = UISwipeActionsConfiguration(actions: [action])
            return configuration
    }

}

import UIKit

extension UIViewController {
    
    /// Adds a subview to the calling `UIViewControler` and constrains it to the edges
    ///
    /// - Parameter subview: view to add as subview and constraint.
    /// - Parameter margin: Optional margin inset to all of the edges of the subview. Defaults to 0.
    func addSubViewWithFillConstraints(_ subview: UIView, margin: CGFloat = 0) {
        view.addSubViewWithFillConstraints(subview, margin: margin)
    }
    
    func add(_ child: UIViewController) {
        child.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    
    // Gio - I want to add the ability to display custom actions when the user swipes a table row,
    // specifically the ability to edit.  The example code below is from
    // https://useyourloaf.com/blog/table-swipe-actions/ where they give the ability to
    // 'favorite' an item.  We'll change this to Edit, but just for starters, do I even have this code in the right place?  And if so, it seems we need to replace dataSource? with something else, but I can't figure out what that it.  Thoughts?
    
    func tableView(_ tableView: UITableView
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        ->   UISwipeActionsConfiguration? {
            
            // Get current state from data source
            guard let edit = dataSource?.edit(at: indexPath) else {
                return nil
            }
            
            let title = edit ?
                NSLocalizedString("Edit", comment: "Edit") :
            
            let action = UIContextualAction(style: .normal, title: title,
                                            handler: { (action, view, completionHandler) in
                                                // Update data source when user taps action
                                                self.dataSource?.setEdit(!edit, at: indexPath)
                                                completionHandler(true)
            })
            
            //action.image = UIImage(named: "heart")
            action.backgroundColor = edit ? .red : .green
            let configuration = UISwipeActionsConfiguration(actions: [action])
            return configuration
    }
    

}

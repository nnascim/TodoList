import UIKit

extension UIViewController {
    
    /// Adds the specified subview to the calling `UIViewControler` and constrains it to the edges.
    ///
    /// - Parameter subview: view to add as subview and constraint.
    /// - Parameter margin: Optional margin inset to all of the edges of the subview. Defaults to 0.
    func addSubViewWithFillConstraints(_ subview: UIView, margin: CGFloat = 0) {
        view.addSubViewWithFillConstraints(subview, margin: margin)
    }
    
    /// Adds the specified view controller as a child of the current view controller.
    ///
    /// This function runs the following code:
    ///
    ///     child.translatesAutoresizingMaskIntoConstraints = false
    ///     addChildViewController(child)
    ///     view.addSubview(child)
    ///     child.didMove(toParentViewController: self)
    ///
    /// - Parameter child: The view controller to be added as a child.
    func add(_ child: UIViewController) {
        child.view.translatesAutoresizingMaskIntoConstraints = false
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    /// Removes the view controller from its parent.
    ///
    /// This function runs the following code:
    ///
    ///     willMove(toParentViewController: nil)
    ///     removeFromParentViewController()
    ///     view.removeFromSuperview()
    ///
    func remove() {
        guard parent != nil else { return }
        
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}

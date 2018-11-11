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
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}

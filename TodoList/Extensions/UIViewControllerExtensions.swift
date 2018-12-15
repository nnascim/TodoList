import UIKit

extension UIViewController {
    
    /// Adds the specified subview to the calling `UIViewControler` and constrains it to the edges.
    ///
    /// - Parameter subview: view to add as subview and constraint.
    /// - Parameter margin: Optional margin inset to all of the edges of the subview. Defaults to 0.
    func addSubViewWithFillConstraints(_ subview: UIView, margin: CGFloat = 0) {
        view.addSubViewWithFillConstraints(subview, margin: margin)
    }
    
    /// Adds the specified view controller as a child of the current view controller, and adds it to the view.
    /// Also calls its delegate ```didMove``` function.
    ///
    /// - Parameter child: The view controller to be added as a child.
    func add(_ child: UIViewController) {
        child.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    /// Removes the view controller from its parent, as well as its superView.
    /// Also calls its delegate ```didMove``` function.
    func remove() {
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}

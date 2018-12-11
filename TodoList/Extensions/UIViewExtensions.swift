import UIKit

extension UIView {
    
    /// Builds a nib.
    ///
    /// - Returns: A nib.
    static func buildNib<T: UIView>() -> T {
        let nibName = self.className
        
        guard let nibView = Bundle(for: T.self).loadNibNamed(nibName, owner: self)?.first as? T else {
            assertionFailure("Unable to load a nibView for \(nibName)")
            return T()
        }
        
        return nibView
    }
   
    /// Adds a subview and constrains it to the edges.
    ///
    /// This function also sets sets false to
    ///
    ///     translatesAutoresizingMaskIntoConstraints
    ///
    /// - Parameter subview: view to add as subview and constraint.
    /// - Parameter margin: Optional margin inset to all of the edges of the subview. Defaults to 0.
    func addSubViewWithFillConstraints(_ subview: UIView, margin: CGFloat = 0) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        subview.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
    }
}

import Foundation

extension NSObject {
    
    /// Convenience variable for obtaining the name of an object's class.
    ///
    /// Use className instead of:
    ///
    ///     object.String(describing: type(of: self))
    ///
    ///
    /// - Returns: String containing the name of the object's class.
    var className: String {
        
        return String(describing: type(of: self))
    }
    
    /// Static class variable for obtaining a class' name.
    ///
    /// Use className instead of:
    ///
    ///     class.String(describing: type(of: self))
    static var className: String {
        return String(describing: self)
    }
}

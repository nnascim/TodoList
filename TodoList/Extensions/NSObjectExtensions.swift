import Foundation

// Extension: To avoid typing string as it is prone to error. EX: TodoListViewController.className
extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    static var className: String {
        return String(describing: self)
    }
}

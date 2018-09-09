import Foundation

// Extension: To Avoid typing string as it is prone to error. EX: TodoListViewController.className
extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}

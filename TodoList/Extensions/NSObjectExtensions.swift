import Foundation

extension NSObject {
    /*asddasasdas
     
 */
    var className: String {
        return String(describing: type(of: self))
    }
    
    static var className: String {
        return String(describing: self)
    }
}

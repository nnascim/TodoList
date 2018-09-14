import Foundation

struct Item: Codable {
    let title: String
    var isComplete: Bool
    
    init(title: String, isComplete: Bool = false) {
        self.title = title
        self.isComplete = isComplete
    }
}

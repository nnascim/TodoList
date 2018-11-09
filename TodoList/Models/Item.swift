import Foundation

struct Item: Codable {
    let title: String
    var completionDate: Date?
    var isComplete: Bool
    
    init(title: String, completionDate: Date? = nil, isComplete: Bool = false) {
        self.title = title
        self.completionDate = completionDate
        self.isComplete = isComplete
    }
}

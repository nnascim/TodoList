import Foundation

struct Item: Codable {
    let id: String
    let title: String
    var isComplete: Bool
    
    init(title: String, isComplete: Bool = false) {
        self.id = UUID().uuidString
        self.title = title
        self.isComplete = isComplete
    }
}

// MARK: - Comparison using id
extension Item {
    var equalById: (_ other: Item) -> Bool {
        let id = self.id
        return { other in
            return id == other.id
        }
    }

    static func equalById(first: Item, second: Item) -> Bool {
        return first.id == second.id
    }
}

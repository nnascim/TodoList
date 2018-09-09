import Foundation

struct Todo: Codable {
    var list: [Item] {
        didSet { self.save() }
    }

    init(items: [Item]) {
      self.list = items
    }
}

struct Item: Codable {
    let title: String
    var isComplete: Bool
    
    init(title: String, isComplete: Bool = false) {
        self.title = title
        self.isComplete = isComplete
    }
}
//NOTE: UserDefaults is a temporary sulution
extension Todo {
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "todoList")
        }
    }

    static func load() -> Todo {
        if let savedItems = UserDefaults.standard.object(forKey: "todoList") as? Data {
            if let loadedItems = try? JSONDecoder().decode(Todo.self, from:savedItems) {
                return loadedItems
            }
        }
        return Todo(items:
                     [Item(title: "Milk"),
                     Item(title: "Juice"),
                     Item(title: "Bread", isComplete: true)])
    }
}

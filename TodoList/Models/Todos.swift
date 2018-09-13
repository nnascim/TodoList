import Foundation

struct Todos: Codable {
    var items: [Item] {
        didSet { self.save() }
    }

    init(items: [Item]) {
        self.items = items
    }
}
//NOTE: UserDefaults is a temporary solution
extension Todos {
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "todoList")
        }
    }

    static func load() -> Todos {
        if let savedItems = UserDefaults.standard.object(forKey: "todoList") as? Data {
            if let loadedItems = try? JSONDecoder().decode(Todos.self, from:savedItems) {
                return loadedItems
            }
        }
        return Todos(items: [])
    }
}

import Foundation

private enum UDKey {
    static let TodoList = "todoList"
}

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
        UserDefaults.standard.set(encodable: self, forKey: UDKey.TodoList)
    }

    static func load() -> Todos {
        return UserDefaults.standard.decodedValue(forKey: UDKey.TodoList) ?? Todos(items: [])
    }
}

// MARK: - Observing changes
protocol TodosObserverDelegate: class {
    func todosObserverDelegate(todosDidChangeTo todos: Todos)
}

extension Todos {
    private static let observer = TodosObserver()

    func addTododsObserver(_ observer: TodosObserverDelegate) {
        Todos.observer.addTododsObserver(observer)
    }

    func removeTodosObserver(_ observer: TodosObserverDelegate) {
        Todos.observer.removeTodosObserver(observer)
    }
}

private class TodosObserver: NSObject {
    private let queue: DispatchQueue = DispatchQueue(label: "TodosObserver.queue",
                                                    qos: .userInitiated,
                                                    attributes: .concurrent)
    private var observers: [TodosObserverDelegate] = []

    override init() {
        super.init()

        UserDefaults.standard.addObserver(self,
                                          forKeyPath: UDKey.TodoList,
                                          options: .new,
                                          context: nil)
    }

    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: UDKey.TodoList, context: nil)
    }


    func addTododsObserver(_ observer: TodosObserverDelegate) {
        queue.async {
            self.observers.append(observer)
        }
    }

    func removeTodosObserver(_ observer: TodosObserverDelegate) {
        queue.async {
            self.observers.removeAll { $0 === observer }
        }
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard keyPath == UDKey.TodoList
            && object is UserDefaults else {
            return
        }

        queue.async {
            let todos = Todos.load()
            self.observers.forEach { delegate in
                delegate.todosObserverDelegate(todosDidChangeTo: todos)
            }
        }
    }
}

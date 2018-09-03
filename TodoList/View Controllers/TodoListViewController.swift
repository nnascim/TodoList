import UIKit

class TodoListViewController: UITableViewController {

    var todos = [Item(title: "Milk"),
                 Item(title: "Juice"),
                 Item(title: "Bread", isComplete: true)]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(cellType: ItemTableViewCell.self)
        title = "To Do List"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)

        let todo = todos[indexPath.row]
        cell.set(text: todo.title, isCompleted: todo.isComplete)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // toggle item completion state
        todos[indexPath.row].isComplete = !todos[indexPath.row].isComplete
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

}

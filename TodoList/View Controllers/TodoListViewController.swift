import UIKit

class TodoListViewController: UITableViewController {

    // MARK: - Properties
    var todos = [Item(title: "Milk"),
                 Item(title: "Juice"),
                 Item(title: "Bread", isComplete: true)]
    
    private lazy var footer: TextFieldView = {
        let footer = TextFieldView.nibView
        footer.delegate = self
        return footer
    }()

    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        
        tableView.register(cellType: ItemTableViewCell.self)
        tableView.tableFooterView = footer
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionFooterHeight = 80
        tableView.sectionFooterHeight = UITableViewAutomaticDimension
        
        title = NSLocalizedString("My List", comment: "")
    }

    // MARK: - TableView dataSource Delegate
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
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Toggle item completion state
        todos[indexPath.row].isComplete = !todos[indexPath.row].isComplete
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

}

// MARK: - TextFieldViewDelegate Extension
extension TodoListViewController: TextFieldViewDelegate {
    func textField(didEnter text: String) {
        let item = Item(title: text)
        todos.append(item)
        let newIndex = IndexPath(row: todos.count-1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [newIndex], with: .automatic)
        tableView.endUpdates()
    }
}

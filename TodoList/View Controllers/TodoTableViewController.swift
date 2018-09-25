import UIKit

protocol TodoTableDelegate: class {
    func didDeleteItem(at index: Int)
    func didSelect(at index: Int)
}

final class TodoTableViewController: UITableViewController {

    // MARK: - Properties
    private var dataSource: [Item]
    weak var delegate: TodoTableDelegate?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    private let emptyView: EmptyView = {
        let emptyView = EmptyView.nibView
        return emptyView
    }()
    
    // MARK: - Life Cycle
    init(dataSource: [Item]) {
        self.dataSource = dataSource
        
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Interface
    func deleteItem(at index: Int) {
        dataSource.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func reload(item: Item, at index: Int) {
        dataSource[index] = item
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func add(item: Item) {
        dataSource.append(item)
        let newIndex = IndexPath(row: dataSource.count-1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [newIndex], with: .automatic)
        tableView.endUpdates()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        
        tableView.register(cellType: ItemTableViewCell.self)
        tableView.keyboardDismissMode = .interactive
    }
    
    private func setState(isEmpty: Bool) {
        tableView.backgroundView = isEmpty ? emptyView : nil
    }
    
    // MARK: - TableView dataSource Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UIView.animate(withDuration: 0.3) {
            self.setState(isEmpty: self.dataSource.isEmpty)
        }
        
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        let item = dataSource[indexPath.row]
        var date: String?
        if let completionDate = item.completionDate {
            date = dateFormatter.string(from: completionDate)
        }
        
        cell.set(title: item.title,
                 subtitle: date,
                 isCompleted: item.isComplete)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            delegate?.didDeleteItem(at: indexPath.row)
        }
    }
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(at: indexPath.row)
    }
}

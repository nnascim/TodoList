import UIKit

protocol TodoTableDelegate: class {
    func didDeleteItem(at index: Int)
    func didSelect(at index: Int)
    func didMoveRow(sourceIndex: Int, destinationIndex: Int)
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
    
    func resetDataSource(with items: [Item]) {
        dataSource = items
        view.layoutIfNeeded()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        tableView.register(cellType: ItemTableViewCell.self)
        tableView.keyboardDismissMode = .interactive
    }
    
    private func setDataSourceState(isEmpty: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.tableView.backgroundView = isEmpty ? self.emptyView : nil
        }
    }
    
    private func completedDate(from item: Item) -> String? {
    
        if let completionDate = item.completionDate {
            return dateFormatter.string(from: completionDate)
        }
        return nil
    }
    
    // MARK: - TableView dataSource Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setDataSourceState(isEmpty: self.dataSource.isEmpty)
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let item = dataSource[indexPath.row]
        
        cell.set(title: item.title,
                 subtitle: completedDate(from: item),
                 isCompleted: item.isComplete)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            delegate?.didDeleteItem(at: indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        delegate?.didMoveRow(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.didSelect(at: indexPath.row)
    }
    
    
}

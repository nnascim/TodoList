import UIKit

final class TodoListViewController: UIViewController {

    // MARK: - Properties
    private lazy var todos: Todos = {
        return Todos.load()
    }()
    
    private lazy var tableViewController: TodoTableViewController = {
        let tableViewController = TodoTableViewController(dataSource: todos.items)
        tableViewController.delegate = self
        add(tableViewController)
        return tableViewController
    }()
    
    private lazy var footer: TextFieldView = {
        let footer = TextFieldView.nibView
        footer.delegate = self
        footer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(footer)
        return footer
    }()
    
    private lazy var footerBottomConstraint: NSLayoutConstraint = {
        let footBottomConstraint = footer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        return footBottomConstraint
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        subscribeToKeyboardEvents()
    }
    
    deinit {
        unsubscribeKeyboardEvents()
    }

    // MARK: - Helpers
    private func setupUI() {

        navigationItem.rightBarButtonItem = editButtonItem
        title = NSLocalizedString("My List", comment: "")
        
        view.addConstraints([
            footer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footer.heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
            footerBottomConstraint,

            tableViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableViewController.view.bottomAnchor.constraint(equalTo: footer.topAnchor)
            ])
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        tableViewController.setEditing(editing, animated: animated)
    }
    
    // MARK: - Keyboard
    private func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeKeyboardEvents() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
       keyboardWill(show: true, keyboardNotification: notification)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
       keyboardWill(show: false, keyboardNotification: notification)
    }
    
    func keyboardWill(show isShow: Bool, keyboardNotification notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        var animationDuration: TimeInterval = 0
        if let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
            animationDuration = duration.doubleValue
        }
        
        var keyboardEndFrame = CGRect.zero
        if let frameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            keyboardEndFrame = frameEnd.cgRectValue
        }
        
        var animationCurve: UInt = 0
        if let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
            animationCurve = curve.uintValue
        }
        
        let animationOptionCurve = UIView.AnimationOptions(rawValue: animationCurve << 16)
        let options: UIView.AnimationOptions = [ UIView.AnimationOptions.beginFromCurrentState, animationOptionCurve]
        
        let anchor = isShow ? view.bottomAnchor : view.safeAreaLayoutGuide.bottomAnchor
        let constant = isShow ? -keyboardEndFrame.height : 0
        view.removeConstraint(footerBottomConstraint)
        footerBottomConstraint = footer.bottomAnchor.constraint(equalTo: anchor, constant: constant)
        footerBottomConstraint.isActive = true
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: - TodoTableDelegate
extension TodoListViewController: TodoTableDelegate {
    
    func didSelect(at index: Int) {
        // Toggle item completion state
        var item = todos.items[index]
        item.isComplete = !item.isComplete
        item.completionDate = item.isComplete ? Date() : nil
        todos.items[index] = item
        todos.save()
        
        tableViewController.reload(item: item, at: index)
    }
    
    func didDeleteItem(at index: Int) {
        todos.items.remove(at: index)
        todos.save()
        
        tableViewController.deleteItem(at: index)
    }
    
    func didMoveRow(sourceIndex: Int, destinationIndex: Int) {
        let item = todos.items[sourceIndex]
        todos.items.remove(at: sourceIndex)
        todos.items.insert(item, at: destinationIndex)
        todos.save()
        
        tableViewController.resetDataSource(with: todos.items)
    }
}

// MARK: - TextFieldViewDelegate Extension
extension TodoListViewController: TextFieldViewDelegate {
    func textField(didEnter text: String) {
        let item = Item(title: text)
        todos.items.append(item)
        
        tableViewController.add(item: item)
    }
}

// Gio - I want to add the ability to display custom actions when the user swipes a table row,
// specifically the ability to edit.  The example code below is from
// https://useyourloaf.com/blog/table-swipe-actions/ where they give the ability to
// 'favorite' an item.  We'll change this to Edit, but just for starters, do I even have this code in the right place?  And if so, it seems we need to replace dataSource? with something else, but I can't figure out what that it.  Thoughts?

func tableView(_ tableView: UITableView,
                        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    ->   UISwipeActionsConfiguration? {
        
        // Get current state from data source
        guard let favorite = dataSource?.favorite(at: indexPath) else {
            return nil
        }
        
        let title = favorite ?
            NSLocalizedString("Unfavorite", comment: "Unfavorite") :
            NSLocalizedString("Favorite", comment: "Favorite")
        
        let action = UIContextualAction(style: .normal, title: title,
                                        handler: { (action, view, completionHandler) in
                                            // Update data source when user taps action
                                            self.dataSource?.setFavorite(!favorite, at: indexPath)
                                            completionHandler(true)
        })
        
        action.image = UIImage(named: "heart")
        action.backgroundColor = favorite ? .red : .green
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
}

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
    
    // MARK: - Keyboard
    private func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
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
        if let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            animationDuration = duration.doubleValue
        }
        
        var keyboardEndFrame = CGRect.zero
        if let frameEnd = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            keyboardEndFrame = frameEnd.cgRectValue
        }
        
        var animationCurve: UInt = 0
        if let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
            animationCurve = curve.uintValue
        }
        
        let animationOptionCurve = UIViewAnimationOptions(rawValue: animationCurve << 16)
        let options: UIViewAnimationOptions = [ UIViewAnimationOptions.beginFromCurrentState, animationOptionCurve]
        
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
        
        tableViewController.reload(item: item, at: index)
    }
    
    func didDeleteItem(at index: Int) {
        todos.items.remove(at: index)
        
        tableViewController.deleteItem(at: index)
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

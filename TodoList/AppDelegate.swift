import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let navController = UINavigationController(rootViewController: TodoListViewController(style: .grouped))
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcut(shortcutItem))
    }

    func handleShortcut(_ shortcutItem: UIApplicationShortcutItem ) -> Bool {
        print("Handling shortcut")
        
        var succeeded = false
        
        if (shortcutItem.type == "io.chuva.TodoList.clear-all") {
            UserDefaults.standard.set(nil, forKey: "todoList")
            let navController = UINavigationController(rootViewController: TodoListViewController(style: .grouped))
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
            succeeded = true
        }
        
        return succeeded
        
    }
}


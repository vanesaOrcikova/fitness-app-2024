import UIKit
import FirebaseAuth
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var authHandle: AuthStateDidChangeListenerHandle?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        // ✅ Zobraz správnu obrazovku podľa toho, či je user prihlásený
        setRootBasedOnAuth(animated: false)

        window.makeKeyAndVisible()

        // ✅ počúvaj zmeny prihlásenia/odhlásenia a prepínaj root automaticky
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, _ in
            self?.setRootBasedOnAuth(animated: true)
        }
    }

    private func setRootBasedOnAuth(animated: Bool) {
        let isLoggedIn = (Auth.auth().currentUser != nil)

        let newRoot: UIViewController
        if isLoggedIn {
            newRoot = RMTabBarController()
        } else {
            newRoot = LoginViewController()
        }

        guard let window = self.window else { return }

        if animated {
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve) {
                window.rootViewController = newRoot
            }
        } else {
            window.rootViewController = newRoot
        }
    }

    // ✅ KRITICKÉ pre návrat z Google Sign-In späť do appky
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        GIDSignIn.sharedInstance.handle(url)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        if let handle = authHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}

//import UIKit
//import FirebaseAuth
//import GoogleSignIn
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//    private var authHandle: AuthStateDidChangeListenerHandle?
//
//    func scene(
//        _ scene: UIScene,
//        willConnectTo session: UISceneSession,
//        options connectionOptions: UIScene.ConnectionOptions
//    ) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//        self.window = window
//
//        // ✅ DEBUG: vždy ukáž login a NEPREPÍNAJ root automaticky
//        #if DEBUG
//        window.rootViewController = LoginViewController()
//        window.makeKeyAndVisible()
//        return
//        #else
//        // ✅ RELEASE: normálne podľa prihlásenia
//        setRootBasedOnAuth(animated: false)
//        window.makeKeyAndVisible()
//
//        // ✅ Listener len v release (aby sa root prepínal po login/logout)
//        authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, _ in
//            self?.setRootBasedOnAuth(animated: true)
//        }
//        #endif
//    }
//
//    private func setRootBasedOnAuth(animated: Bool) {
//        let isLoggedIn = (Auth.auth().currentUser != nil)
//
//        let newRoot: UIViewController
//        if isLoggedIn {
//            newRoot = RMTabBarController()
//        } else {
//            newRoot = LoginViewController()
//        }
//
//        guard let window = self.window else { return }
//
//        if animated {
//            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve) {
//                window.rootViewController = newRoot
//            }
//        } else {
//            window.rootViewController = newRoot
//        }
//    }
//
//    // ✅ KRITICKÉ pre návrat z Google Sign-In späť do appky
//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//        guard let url = URLContexts.first?.url else { return }
//        GIDSignIn.sharedInstance.handle(url)
//    }
//
//    func sceneDidDisconnect(_ scene: UIScene) {
//        if let handle = authHandle {
//            Auth.auth().removeStateDidChangeListener(handle)
//        }
//    }
//
//    func sceneDidBecomeActive(_ scene: UIScene) { }
//    func sceneWillResignActive(_ scene: UIScene) { }
//    func sceneWillEnterForeground(_ scene: UIScene) { }
//    func sceneDidEnterBackground(_ scene: UIScene) { }
//}

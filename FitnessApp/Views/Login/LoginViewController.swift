import UIKit
import SwiftUI

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hostingController = UIHostingController(rootView: LoginView(onLoginSuccess: {
            navigateToMainTabBarController()
        }))


        // Add the hosting controller as a child view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        // Set up constraints for the hosting controller's view
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        func navigateToMainTabBarController() {
            let mainTabBarController = RMTabBarController() // Initialize your main tab bar controller here
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = mainTabBarController
                window.makeKeyAndVisible()
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        }
    }
}

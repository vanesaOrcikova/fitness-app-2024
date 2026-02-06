import UIKit
import SwiftUI
import FirebaseAuth
import GoogleSignIn

final class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // ✅ PrettyLoginView zavolá callback -> startGoogleSignIn()
        let loginView = PrettyLoginView { [weak self] in
            self?.startGoogleSignIn()
        }

        let host = UIHostingController(rootView: loginView)
        addChild(host)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(host.view)

        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        host.didMove(toParent: self)
    }

    private func startGoogleSignIn() {
        // ✅ Toto je presne to, čo ti fungovalo v LoginView
        // Potrebujeme "presenting" view controller
        FirebAuth.shared.signInWithGoogle(presenting: self) { success in
            if success {
                print("✅ Logged in")
                // SceneDelegate listener to už prepne automaticky
            } else {
                print("❌ Login failed")
            }
        }
    }
}

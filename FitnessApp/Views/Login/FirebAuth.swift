import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UIKit

final class FirebAuth {

    static let shared = FirebAuth()
    private init() {}

    // ✅ Získa ClientID:
    // 1) ideálne z FirebaseApp options (ak máš správny GoogleService-Info.plist)
    // 2) fallback: z Info.plist URL scheme -> spraví z toho klasický clientID
    private func resolveClientID() -> String? {

        if let clientID = FirebaseApp.app()?.options.clientID, !clientID.isEmpty {
            return clientID
        }

        // Fallback: z URL scheme typu "com.googleusercontent.apps.XXX"
        if let urlTypes = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: Any]] {
            for item in urlTypes {
                if let schemes = item["CFBundleURLSchemes"] as? [String] {
                    for scheme in schemes {
                        if scheme.hasPrefix("com.googleusercontent.apps.") {
                            let suffix = scheme.replacingOccurrences(of: "com.googleusercontent.apps.", with: "")
                            // z "1015...-abcd" spravíme "1015...-abcd.apps.googleusercontent.com"
                            return "\(suffix).apps.googleusercontent.com"
                        }
                    }
                }
            }
        }

        return nil
    }

    func signInWithGoogle(
        presenting viewController: UIViewController,
        completion: @escaping (Bool) -> Void
    ) {

        guard let clientID = resolveClientID() else {
            print("❌ Missing Google ClientID. Skontroluj GoogleService-Info.plist alebo URL scheme v Info.plist.")
            DispatchQueue.main.async { completion(false) }
            return
        }

        print("✅ Using Google clientID:", clientID)

        let configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration

        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error {
                print("❌ Google Sign-In error:", error)
                DispatchQueue.main.async { completion(false) }
                return
            }

            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString
            else {
                print("❌ Missing Google token/user.")
                DispatchQueue.main.async { completion(false) }
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("❌ Firebase login error:", error)
                        completion(false)
                    } else {
                        print("✅ Login successful")
                        completion(true)
                    }
                }
            }
        }
    }

    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            print("❌ Sign out error:", error)
            return false
        }
    }
}

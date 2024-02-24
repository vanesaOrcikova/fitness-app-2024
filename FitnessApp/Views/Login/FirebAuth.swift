import Foundation
import FirebaseAuth
import GoogleSignIn
import Firebase

struct FirebAuth {
    static let share = FirebAuth()
    static public var window : UIWindow?
    
    private init() {}
    
    static func isUserLoggedIn() -> Bool {
          return Auth.auth().currentUser != nil
    } //ci uzivatel je prihlaseny
    
    //ak uzivatel neexistuje vo firebase databaze tak sa musi znovu prihlasit do aplikacie
    static func loggedOutIfUserIsNotValid(completion: @escaping (Bool) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            currentUser.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error as NSError?, error.code == AuthErrorCode.userNotFound.rawValue {
                    // User account doesn't exist anymore, sign out
                    do {
                        try Auth.auth().signOut()
                        // Update UserDefaults or any other local state
                        UserDefaults.standard.set(false, forKey: "signIn")
                        completion(true) // User logged out successfully
                    } catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError)
                        completion(false) // Failed to log out
                    }
                } else {
                    // No error, user still valid
                    completion(false) // User is still valid, no log out performed
                }
            }
        } else {
            // No current user
            completion(false) // No user to log out
        }
    }
    
    static func logOutCurrentUser(completion: @escaping (Bool) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            do {
                try Auth.auth().signOut()
                // Update UserDefaults or any other local state
                UserDefaults.standard.set(false, forKey: "signIn")
                completion(true) // User logged out successfully
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
                completion(false) // Failed to log out
            }
        } else {
            // No current user
            completion(false) // No user to log out
        }
    }

    static func signInWithGoogle(presentingViewController: UIViewController, completion: @escaping (Error?) -> Void) {
           guard let clientID = FirebaseApp.app()?.options.clientID else {
               completion(NSError(domain: "FirebaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve client ID"]))
               return
           }

           // Create Google Sign In configuration object.
           let config = GIDConfiguration(clientID: clientID)
           GIDSignIn.sharedInstance.configuration = config

           // Start the sign in flow!
           GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { user, error in
               guard error == nil else {
                   completion(error)
                   return
               }

               guard let user = user?.user,
                     let idToken = user.idToken?.tokenString else {
                   completion(NSError(domain: "GoogleSignInError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve ID token"]))
                   return
               }

               let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

               Auth.auth().signIn(with: credential) { result, error in
                   guard error == nil else {
                       completion(error)
                       return
                   }
                   
                   print("Sign In")
                   UserDefaults.standard.set(true, forKey: "signIn")
                   completion(nil)
               }
           }
       }
}

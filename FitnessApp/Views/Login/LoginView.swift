import SwiftUI

struct LoginView: View {

    var body: some View {
        VStack(spacing: 24) {

            Spacer()

            Text("Healthy Me")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Sign in to continue")
                .foregroundColor(.gray)

            Spacer()

            GoogleSignInBtn {
                if let rootVC = UIApplication.shared.rootViewController {
                    FirebAuth.shared.signInWithGoogle(
                        presenting: rootVC
                    ) { success in
                        if success {
                            print("✅ Logged in")
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
    }
}




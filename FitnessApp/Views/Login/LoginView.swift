import SwiftUI

struct LoginView: View {
    var onLoginSuccess: () -> Void  // Closure to be called on successful login

    var body: some View {
        NavigationView {
            ZStack {
                Color(.white).edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Image("imgHome")
                        .resizable()
                        .scaledToFit()
                        .offset(y:-25)
                    Spacer()

        
                    Text("BE FIT")
                        .font(.system(size: 20))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .offset(y:-65)
        
                    Text("Please sing in to your Fitness account to continue.")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color(.black))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 26)
                        //.padding(.bottom, 40)
                        .offset(y:-50)
        
                    
                    GoogleSigInBtn {
                        FirebAuth.signInWithGoogle(presentingViewController: getRootViewController()) { error in
                            if let error = error {
                                // Handle the error
                                print("Error signing in: \(error.localizedDescription)")
                            } else {
                                // Call the closure upon successful login
                                self.onLoginSuccess()
                            }
                        }
                        
                    }
        
                }
                .padding()
                .overlay(
                    HStack {
                        Image(systemName: "figure.walk") // Použitie symbolu figure.walk
                            .font(.system(size: 20))
                            .foregroundColor(Color(.black))
                        Text("VanFitness")
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            .foregroundColor(Color(.black))
                        }
                        .padding(.top, 10)
                        .padding(.leading, 10)
                    , alignment: .topLeading)
            }
            .padding(.top, 52)
            Spacer()
        }
    
    }
}




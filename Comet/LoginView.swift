import SwiftUI
import GoogleSignIn
import Twift

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var age: String = ""
    @State private var gender: String = "Male"
    @State private var showSignUp = false
    @State private var isLoggedIn = false
    @State private var twitterClient: Twift?

    var body: some View {
        VStack {
            Text("Welcome to Comet").font(.largeTitle).bold()
            
            if showSignUp {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Age", text: $age)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Picker("Gender", selection: $gender) {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                    Text("Other").tag("Other")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Button("Sign Up") {
                    signUpWithEmail()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            } else {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Login") {
                    loginWithEmail()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            
            Divider().padding()
            
            HStack {
                GoogleSignInButtonView()
                    .frame(height: 50)
                    .padding()
                
                Button(action: signInWithTwitter) {
                    Image("twitter_logo")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                .padding()
            }
            
            Button(showSignUp ? "Already have an account? Login" : "Create an account") {
                showSignUp.toggle()
            }
            .padding()
        }
        .onReceive(NotificationCenter.default.publisher(for: .twitterOAuthCallback)) { notification in
            if let url = notification.userInfo?["url"] as? URL {
                handleTwitterOAuthCallback(url: url)
            }
        }
    }

    func signUpWithEmail() {
        print("User Signed Up: \(email), \(password), \(age), \(gender)")
    }

    func loginWithEmail() {
        print("User Logged In: \(email)")
    }

    func signInWithGoogle() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = scene.windows.first?.rootViewController else {
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            guard let user = result?.user, error == nil else { return }
            let email = user.profile?.email ?? ""
            print("Google Login Success: \(email)")
        }
    }

    /// Twitter 登录
    func signInWithTwitter() {
        Task {
            do {
                let oauthUser = try await Twift.Authentication().authenticateUser(
                    clientId: "emFpY2R2QlYyUDA3TUFFUGo5MEg6MTpjaQ",
                    redirectUri: URL(string: "com.comet://callback")!,
                    scope: Set(OAuth2Scope.allCases)
                )
                
                twitterClient = Twift(oauth2User: oauthUser, onTokenRefresh: saveUserCredentials)
                saveUserCredentials(oauthUser)
                
                print("Twitter Login Success!")
            } catch {
                print("Twitter Login Failed: \(error.localizedDescription)")
            }
        }
    }

    func saveUserCredentials(_ oauthUser: OAuth2User) {
        print("Saving Twitter Credentials")
    }

    func handleTwitterOAuthCallback(url: URL) {
        Task {
            do {
                let oauthUser = try await Twift.Authentication().authenticateUser(
                    clientId: "emFpY2R2QlYyUDA3TUFFUGo5MEg6MTpjaQ",
                    redirectUri: URL(string: "com.comet://callback")!,
                    scope: Set(OAuth2Scope.allCases)
                )
                
                twitterClient = Twift(oauth2User: oauthUser, onTokenRefresh: saveUserCredentials)
                saveUserCredentials(oauthUser)
                
                print("Twitter OAuth Callback Handled Successfully!")
            } catch {
                print("Twitter OAuth Callback Error: \(error.localizedDescription)")
            }
        }
    }
}

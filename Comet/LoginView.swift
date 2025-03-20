//
//  LoginView.swift
//  Comet
//
//  Created by 小序 on 3/20/25.
//


import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import TwitterKit

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var age: String = ""
    @State private var gender: String = "Male"
    @State private var showSignUp = false
    @State private var isLoggedIn = false
    
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
                GoogleSignInButton(action: signInWithGoogle)
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
    }
    
    // 邮箱注册逻辑
    func signUpWithEmail() {
        // 这里你需要调用 API 将 email, password, age, gender 发送到后端
        print("User Signed Up: \(email), \(password), \(age), \(gender)")
    }
    
    // 邮箱登录逻辑
    func loginWithEmail() {
        // 这里你需要调用 API 验证 email 和 password
        print("User Logged In: \(email)")
    }
    
    // Google 登录
    func signInWithGoogle() {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            guard let user = result?.user, error == nil else { return }
            let email = user.profile?.email ?? ""
            print("Google Login Success: \(email)")
        }
    }
    
    // Twitter 登录
    func signInWithTwitter() {
        TWTRTwitter.sharedInstance().logIn { session, error in
            if let session = session {
                print("Twitter Login Success: \(session.userName)")
            } else {
                print("Twitter Login Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
}

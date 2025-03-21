//
//  GoogleSignInButtonView.swift
//  Comet
//
//  Created by 小序 on 3/20/25.
//

import SwiftUI
import GoogleSignIn

struct GoogleSignInButtonRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> GIDSignInButton {
        return GIDSignInButton()
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: Context) {}
}

struct GoogleSignInButtonView: View {
    var body: some View {
        GoogleSignInButtonRepresentable()
            .frame(height: 50)
            .padding()
    }
}

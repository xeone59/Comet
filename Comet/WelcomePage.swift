//
//  WelcomePage.swift
//  Comet
//
//  Created by 小序 on 3/18/25.
//


import SwiftUI

struct WelcomePage: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            LoginView()  // 自动跳转到登录页
        } else {
            VStack {
                Image("Comet_Logo") // 替换成你的 Logo 图片
                    .resizable()
                    .scaledToFit()
                    .frame(width: 170, height: 170)

                Text("Welcome to Comet !!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.top, 10)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

struct WelcomePage_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePage()
    }
}

//
//  CometApp.swift
//  Comet
//
//  Created by 小序 on 3/15/25.
//

import SwiftUI

@main
struct CometApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    print("后端 API 地址: \(API.baseURL)")
                }
        }
    }
}

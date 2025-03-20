//
//  AppDelegate.swift
//  Comet
//
//  Created by 小序 on 3/20/25.
//


import UIKit
import GoogleSignIn
import TwitterKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: "YOUR_GOOGLE_CLIENT_ID")
        
        TWTRTwitter.sharedInstance().start(
            withConsumerKey: "YOUR_TWITTER_CONSUMER_KEY",
            consumerSecret: "YOUR_TWITTER_CONSUMER_SECRET"
        )
        
        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return GIDSignIn.sharedInstance.handle(url) || TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
}

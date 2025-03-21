import UIKit
import GoogleSignIn
import Twift

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var twitterClient: Twift?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: "313902942564-3c0so7sn2kq46fcma6u5k955ggt0jfpe.apps.googleusercontent.com")
        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        // Handle Google Sign-In callback
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }
        
        // Handle Twitter OAuth callback
        if url.scheme == "com.comet" { // Ensure this matches your redirect URI scheme
            NotificationCenter.default.post(name: .twitterOAuthCallback, object: nil, userInfo: ["url": url])
            return true
        }
        
        return false
    }
}

// Notification name for Twitter OAuth callback
extension Notification.Name {
    static let twitterOAuthCallback = Notification.Name("TwitterOAuthCallback")
}

//
//  AppDelegate.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 04.06.23.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import IQKeyboardManagerSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().tintColor = .label
        UINavigationBar.appearance().backIndicatorImage = .backTailedArrow
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = .backTailedArrow
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for:UIBarMetrics.default)
        UITextField.appearance().tintColor = .appBrown
        UITextView.appearance().tintColor = .appBrown
        FirebaseApp.configure()
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarTintColor = .appBrown_white
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let userId = UserDefaults.standard.currentUser?.id {
            let request = UpdateFCMTokenRequest(userId: userId, token: fcmToken ?? "")
            NetworkService.shared.updateFCMToken(request: request)
            UserDefaults.standard.fcmToken = fcmToken
        }
    }
}

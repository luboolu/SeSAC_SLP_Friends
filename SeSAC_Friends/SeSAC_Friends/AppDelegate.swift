//
//  AppDelegate.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/18.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in }
        application.registerForRemoteNotifications()
        
        //네비게이션&탭바 폰트 설정
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont().Title3_M14], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont().Title3_M14], for: .highlighted)
        UINavigationBar.appearance().titleTextAttributes = [ NSAttributedString.Key.font: UIFont().Title3_M14]
        UINavigationBar.appearance().backgroundColor = UIColor().white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont().Body4_R12], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont().Body4_R12], for: .highlighted)
        UITabBar.appearance().tintColor = UIColor().green
        
        //파이어베이스 메시지 대리자 설정
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }

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

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        UserDefaults.standard.set(fcmToken, forKey: UserdefaultKey.fcmToken.rawValue)
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

}



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
        
        
        //네비게이션&탭바 폰트 설정
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont().Title3_M14], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont().Title3_M14], for: .highlighted)
        UINavigationBar.appearance().titleTextAttributes = [ NSAttributedString.Key.font: UIFont().Title3_M14]
        UINavigationBar.appearance().backgroundColor = UIColor().white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont().Body4_R12], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont().Body4_R12], for: .highlighted)
        UITabBar.appearance().tintColor = UIColor().green
        
//        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in }
//        application.registerForRemoteNotifications()
        //알림등록(권한)
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
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

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                  -> Void) {
        //푸시가 뜰때 실행됨(사용자 클릭x) -> 어떤 푸시인지에 따라 사용자 상태를 바꿔줘야힘
        let userInfo = notification.request.content.userInfo

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // ...

      // Print full message.
        print("푸시 내용")
        print(userInfo)

        // Change this to your preferred presentation option
        completionHandler([[.alert, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        //사용자가 푸시를 클릭했을때 -> 푸시 내용에 따른 화면 전환 관련 코드 작성 필요
        let userInfo = response.notification.request.content.userInfo

        // ...

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print full message.
        print("푸시 내용")
        print(userInfo)

        completionHandler()
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



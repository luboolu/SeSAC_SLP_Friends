//
//  SceneDelegate.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let userViewModel = UserViewModel()
    
    private func getUserInfo(_ scene: UIScene) {
        userViewModel.getUser { apiResult, getUserResult, userInfo in
            if let getUserResult = getUserResult {
                
                DispatchQueue.main.async {
                    guard let windowScene = (scene as? UIWindowScene) else { return }
                    self.window = UIWindow(windowScene: windowScene)
                    
                    switch getUserResult {
                    case .existingUser:
                        let vc = MainViewController()
                        let nav = UINavigationController(rootViewController: vc)
                        
                        self.window?.rootViewController = nav
                        self.window?.makeKeyAndVisible()
                    case .newUser:
                        let vc = OnBoardingViewController()
                        let nav = UINavigationController(rootViewController: vc)
                        
                        self.window?.rootViewController = nav
                        self.window?.makeKeyAndVisible()
                    case .tokenError:
                        self.getUserInfo(scene)
                        return
                    case .serverError:
                        print("에러")
                        let vc = OnBoardingViewController()
                        let nav = UINavigationController(rootViewController: vc)
                        
                        self.window?.rootViewController = nav
                        self.window?.makeKeyAndVisible()
                    case .clientError:
                        print("에러")
                        let vc = OnBoardingViewController()
                        let nav = UINavigationController(rootViewController: vc)
                        
                        self.window?.rootViewController = nav
                        self.window?.makeKeyAndVisible()
                    }
                }

            }
        }
    }


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        //온보딩 화면 진입 시 분기 처리
        //0. 앱 최초 실행인지 확인 - userdefault를 통해서!
        //1. 최초 실행이 아니라면, UserViewModel.getUser()를 통해서 회원인지 확인
        //2. 회원이라면 main화면으로 바로 진입
        //3. 회원이 아니라면 onboarding 화면으로 진입
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        //var vc = OnBoardingViewController()
        
        //1. 앱 최초 실행인지 확인
        // -> UserDefault에 전화번호 저장되어 있는지 확인
        if UserDefaults.standard.string(forKey: UserdefaultKey.phoneNumber.rawValue) == nil {
            let vc = OnBoardingViewController()
            let nav = UINavigationController(rootViewController: vc)
            
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
        } else {
            
            getUserInfo(scene)

//            userViewModel.getUser { apiResult, getUserResult, userInfo in
//                if getUserResult == .existingUser {
//
//                } else if getUserResult == .tokenError {
//
//                } else {
//                    let vc = OnBoardingViewController()
//                    let nav = UINavigationController(rootViewController: vc)
//
//                    self.window?.rootViewController = nav
//                    self.window?.makeKeyAndVisible()
//                }
//            }
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


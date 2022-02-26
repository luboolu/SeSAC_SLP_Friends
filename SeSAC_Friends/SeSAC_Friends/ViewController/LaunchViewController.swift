//
//  LaunchViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/26.
//

import UIKit

import JGProgressHUD

final class LaunchViewController: UIViewController {
    
    private let userViewModel = UserViewModel()
    private let hud = JGProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud.show(in: self.view)
        findBranch()
        
        view.backgroundColor = UIColor().white
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hud.dismiss(animated: true)
    }
    
    private func findBranch() {
        //온보딩 화면 진입 시 분기 처리
        //0. 앱 최초 실행인지 확인 - userdefault를 통해서!
        //1. 최초 실행이 아니라면, UserViewModel.getUser()를 통해서 회원인지 확인
        //2. 회원이라면 main화면으로 바로 진입
        //3. 회원이 아니라면 onboarding 화면으로 진입


        //1. 앱 최초 실행인지 확인
        // -> UserDefault에 전화번호 저장되어 있는지 확인
        if UserDefaults.standard.string(forKey: UserdefaultKey.phoneNumber.rawValue) == nil {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            
            let vc = OnBoardingViewController()
            windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
            windowScene.windows.first?.makeKeyAndVisible()
        } else {
            getUserInfo()
        }
    }
    
    private func getUserInfo() {
        userViewModel.getUser { apiResult, getUserResult, userInfo in
            if let getUserResult = getUserResult {
                DispatchQueue.main.async {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

                    switch getUserResult {
                    case .existingUser:
                        if let userInfo = userInfo {
                            UserDefaults.standard.set(userInfo.uid, forKey: UserdefaultKey.uid.rawValue)
                            UserDefaults.standard.set(userInfo.phoneNumber ,forKey: UserdefaultKey.phoneNumber.rawValue)
                            UserDefaults.standard.set(userInfo.gender ,forKey: UserdefaultKey.gender.rawValue)
                            UserDefaults.standard.set(userInfo.email ,forKey: UserdefaultKey.email.rawValue)
                            UserDefaults.standard.set(userInfo.nick, forKey: UserdefaultKey.nickname.rawValue)
                        }
                        
                        let vc = MainViewController()
                        
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                        windowScene.windows.first?.makeKeyAndVisible()
                    case .newUser:
                        let vc = OnBoardingViewController()
                        
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                        windowScene.windows.first?.makeKeyAndVisible()
                    case .tokenError:
                        self.getUserInfo()
                        return
                    case .serverError:
                        print("에러")
                        let vc = OnBoardingViewController()
                        
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                        windowScene.windows.first?.makeKeyAndVisible()
                    case .clientError:
                        print("에러")
                        let vc = OnBoardingViewController()
                        
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                        windowScene.windows.first?.makeKeyAndVisible()
                    }
                }
            }
        }
    }

}

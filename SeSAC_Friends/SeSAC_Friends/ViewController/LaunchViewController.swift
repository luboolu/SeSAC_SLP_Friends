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
    
    private func newUserGuide() {
        //사용자가 회원가입 단계를 어디까지 진행했는지에 따라서 어느 지점으로 화면을 전환해줄지 정해야함!
        var userSign = [0, 0, 0, 0, 0]
        if UserDefaults.standard.string(forKey: UserdefaultKey.phoneNumber.rawValue) != nil {
            userSign[0] = 1
        }
        
        if UserDefaults.standard.string(forKey: UserdefaultKey.nickname.rawValue) != nil {
            userSign[1] = 1
        }
        
        if UserDefaults.standard.string(forKey: UserdefaultKey.birthDay.rawValue) != nil {
            userSign[2] = 1
        }
        
        if UserDefaults.standard.string(forKey: UserdefaultKey.email.rawValue) != nil {
            userSign[3] = 1
        }
        
        if UserDefaults.standard.string(forKey: UserdefaultKey.gender.rawValue) != nil {
            userSign[4] = 1
        }
        //1. 휴대폰 인증
        //2. 닉네임 입력
        //3. 생년월일 입력
        //4. 이메일 입력
        //5. 성별 입력
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        print(userSign)
        if userSign[0] == 1 && userSign[1] == 0 {
            //온보딩
            let vc = OnBoardingViewController()
            windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
            windowScene.windows.first?.makeKeyAndVisible()
        } else if userSign[1] == 1 && userSign[2] == 0 {
            //생년월일
            let vc = BirthViewController()
            windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
            windowScene.windows.first?.makeKeyAndVisible()
        } else if userSign[2] == 1 && userSign[3] == 0 {
            //이메일
            let vc = EmailViewController()
            windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
            windowScene.windows.first?.makeKeyAndVisible()
        } else if userSign[3] == 1 && userSign[4] == 0 {
            //성별
            let vc = GenderViewController()
            windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
            windowScene.windows.first?.makeKeyAndVisible()
        } else {
            //온보딩
            let vc = OnBoardingViewController()
            windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
            windowScene.windows.first?.makeKeyAndVisible()
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
                            UserDefaults.standard.set(userInfo.sesac, forKey: UserdefaultKey.shopCharacter.rawValue)
                            UserDefaults.standard.set(userInfo.background, forKey: UserdefaultKey.shopBackground.rawValue)
                        }
                        
                        let vc = MainViewController()
                        
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                        windowScene.windows.first?.makeKeyAndVisible()
                    case .newUser:
                        self.newUserGuide()
                    case .tokenError:
                        self.getUserInfo()
                        return
                    case .serverError:
                        let vc = OnBoardingViewController()
                        
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                        windowScene.windows.first?.makeKeyAndVisible()
                    case .clientError:
                        let vc = OnBoardingViewController()
                        
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                        windowScene.windows.first?.makeKeyAndVisible()
                    }
                }
            }
        }
    }

}

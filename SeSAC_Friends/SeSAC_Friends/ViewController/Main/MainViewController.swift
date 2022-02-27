//
//  MainViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/26.
//

import UIKit

import Toast

final class MainViewController: UITabBarController {
    
    let viewModel = UserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("authVerificationID")
        print(UserDefaults.standard.string(forKey: UserdefaultKey.authVerificationID.rawValue) ?? "")

        print("idtoken")
        print(UserDefaults.standard.string(forKey: UserdefaultKey.idToken.rawValue) ?? "")

        print("fcmToken")
        print(UserDefaults.standard.string(forKey: UserdefaultKey.fcmToken.rawValue) ?? "")

        self.delegate = self
        self.getUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let homeTab = HomeViewController()
        let homeTabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_color"))
        homeTab.tabBarItem = homeTabBarItem
        
        let shopTab = ShopViewController()
        let shopNav = UINavigationController(rootViewController: shopTab)
        let shopTabBarItem = UITabBarItem(title: "새싹샵", image: UIImage(named: "shop"), selectedImage: UIImage(named: "shop_color"))
        shopNav.tabBarItem = shopTabBarItem
        
        let myPageTab = MyPageViewController()
        let myPageNav = UINavigationController(rootViewController: myPageTab)
        let myPageTabBarItem = UITabBarItem(title: "내정보", image: UIImage(named: "person"), selectedImage: UIImage(named: "person_color"))
        myPageNav.tabBarItem = myPageTabBarItem

        self.viewControllers = [homeTab, shopNav, myPageNav]
    }
    
    private func getUser() {
        viewModel.getUser { apiResult, getUserResult, userInfo in
            if let getUserResult = getUserResult {
                switch getUserResult {
                case .existingUser:
                    print("시작")
                case .tokenError:
                    self.getUser()
                case .newUser:
                    DispatchQueue.main.async {
                        //온보딩 화면으로 이동
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: OnBoardingViewController())
                        windowScene.windows.first?.makeKeyAndVisible()
                    }
                case .serverError:
                    DispatchQueue.main.async {
                        self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: .defaultStyle)
                    }
                case .clientError:
                    DispatchQueue.main.async {
                        self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: .defaultStyle)
                    }
                }
            }
        }
    }

}

extension MainViewController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("selected \(viewControllers?.description)")
    }
    
}

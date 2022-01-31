//
//  MainViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/26.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("authVerificationID")
        print(UserDefaults.standard.string(forKey: UserdefaultKey.authVerificationID.string) ?? "")
        
        print("idtoken")
        print(UserDefaults.standard.string(forKey: UserdefaultKey.idToken.string) ?? "")
        
        print("fcmToken")
        print(UserDefaults.standard.string(forKey: UserdefaultKey.fcmToken.string) ?? "")

        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let homeTab = HomeViewController()
        let homeTabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_color"))
        homeTab.tabBarItem = homeTabBarItem
        
        let shopTab = ShopViewController()
        let shopTabBarItem = UITabBarItem(title: "새싹샵", image: UIImage(named: "shop"), selectedImage: UIImage(named: "shop_color"))
        shopTab.tabBarItem = shopTabBarItem
        
        let friendsTab = FriendsViewController()
        let friendsTabBarItem = UITabBarItem(title: "새싹친구", image: UIImage(named: "sac"), selectedImage: UIImage(named: "sac_color"))
        friendsTab.tabBarItem = friendsTabBarItem
        
        let myPageTab = MyPageViewController()
        let myPageTabBarItem = UITabBarItem(title: "내정보", image: UIImage(named: "person"), selectedImage: UIImage(named: "person_color"))
        myPageTab.tabBarItem = myPageTabBarItem

        self.viewControllers = [homeTab, shopTab, friendsTab, myPageTab]
        
    }

}

extension MainViewController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("selected \(viewControllers?.description)")
    }
    
}

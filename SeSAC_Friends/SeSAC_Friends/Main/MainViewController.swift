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

        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let homeTab = HomeViewController()
        let homeTabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_color"))
        homeTab.tabBarItem = homeTabBarItem
        
        let myPageTab = MyPageViewController()
        let myPageTabBarItem = UITabBarItem(title: "내정보", image: UIImage(named: "person"), selectedImage: UIImage(named: "person_color"))
        myPageTab.tabBarItem = myPageTabBarItem

        self.viewControllers = [homeTab, myPageTab]
        
    }

}

extension MainViewController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("selected \(viewControllers?.description)")
    }
    
}

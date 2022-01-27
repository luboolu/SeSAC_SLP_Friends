//
//  MyPageViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/26.
//

import UIKit

import SnapKit
import SwiftUI

class MyPageViewController: UIViewController {
    
    let mainView = MyPageView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setConstraints()
    }
    
    let menuList = ["공지사항", "자주 묻는 질문", "1:1 문의", "알림 설정", "이용 약관"]
    let menuIconList = ["notice", "faq", "qna" ,"bell", "permit"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor().black
        self.navigationController?.navigationBar.topItem?.title = "내정보"
    }
    
    func setUp() {
        view.backgroundColor = UIColor().white
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(IconTableViewCell.self, forCellReuseIdentifier: "IconTableViewCell")
        mainView.tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")

    }
    
    func setConstraints() {
        

        
    }
    
    
    @objc func profileDetailButtonClicked() {
        print(#function)
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 72
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as? ProfileTableViewCell else { return UITableViewCell()}
            
            cell.profileImage.image = UIImage(named: "sesac_face_1")
            cell.nicknameLabel.text = "새싹이"
            cell.detailButton.addTarget(self, action: #selector(profileDetailButtonClicked), for: .touchUpInside)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IconTableViewCell") as? IconTableViewCell else { return UITableViewCell()}
            
            cell.icon.image = UIImage(named: "\(self.menuIconList[indexPath.row])")
            cell.label.text = "\(self.menuList[indexPath.row])"
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let vc = MyInfoViewController()
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}

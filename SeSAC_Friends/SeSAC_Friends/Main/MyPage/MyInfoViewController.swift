//
//  MyInfoViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/26.
//

import UIKit

import SnapKit

class MyInfoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.tintColor = UIColor().black
        self.navigationItem.title = "정보 관리"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
    }
    
    func setUp() {
        view.backgroundColor = UIColor().white
    }
    
    func setConstraints() {
        
    }
        
    @objc func saveButtonClicked() {
        print(#function)
    }
        
}

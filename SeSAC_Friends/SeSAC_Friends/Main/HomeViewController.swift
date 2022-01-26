//
//  MainViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/22.
//

import UIKit

import SnapKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setUp() {
        
        view.backgroundColor = UIColor().whitegreen
    }
    
    func setConstraints() {
        
    }

}

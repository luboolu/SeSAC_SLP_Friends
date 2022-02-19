//
//  ShopViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/26.
//

import UIKit

import SnapKit

final class ShopViewController: UIViewController {
    
    private let mainView = ShopView()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor().black
        self.navigationController?.navigationBar.topItem?.title = "새싹샵"
    }
    
    func setUp() {

    }
    
    func setConstraints() {
        
    }
}

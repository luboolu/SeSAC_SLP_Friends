//
//  HobbySearchViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/03.
//

import UIKit

class HobbySearchViewController: UIViewController {
    
    let mainView = HobbySearchView()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        
        return searchBar
    }()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}

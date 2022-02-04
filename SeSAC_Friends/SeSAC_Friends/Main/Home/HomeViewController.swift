//
//  MainViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/22.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class HomeViewController: UIViewController {

    private let mainView = HomeView()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupButton()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = UIColor().gray7
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupView() {
        view.backgroundColor = UIColor().white
    }
    
    private func setupButton() {
        mainView.searchButton.rx.tap
            .bind {
                print("tapped!")
                let vc = HobbySearchViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }

}

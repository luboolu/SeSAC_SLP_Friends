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
    
    private let disposeBag = DisposeBag()

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

    }
    
    private func setupButton() {
        //searchButton
        mainView.searchButton.rx.tap
            .bind {
                print("tapped!")
                let vc = HobbySearchViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        //gender filter button
        mainView.genderButton1.rx.tap
            .scan(mainView.genderButton1.status) { lastState, newState in
                self.mainView.genderButton2.status = .inactive
                self.mainView.genderButton3.status = .inactive
                return .fill
            }
            .map{ $0 }
            .bind(to: mainView.genderButton1.rx.status)
            .disposed(by: disposeBag)
        
        mainView.genderButton2.rx.tap
            .scan(mainView.genderButton1.status) { lastState, newState in
                self.mainView.genderButton1.status = .inactive
                self.mainView.genderButton3.status = .inactive
                return .fill
            }
            .map{ $0 }
            .bind(to: mainView.genderButton2.rx.status)
            .disposed(by: disposeBag)
        
        mainView.genderButton3.rx.tap
            .scan(mainView.genderButton1.status) { lastState, newState in
                self.mainView.genderButton1.status = .inactive
                self.mainView.genderButton2.status = .inactive
                return .fill
            }
            .map{ $0 }
            .bind(to: mainView.genderButton3.rx.status)
            .disposed(by: disposeBag)
        
        mainView.locationButton.rx.tap
            .bind {
                print("location button tap")
            }.disposed(by: disposeBag)
    }

}

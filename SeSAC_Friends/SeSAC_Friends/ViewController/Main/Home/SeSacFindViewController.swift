//
//  SeSacFindViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/08.
//

import UIKit

import RxCocoa
import RxSwift

final class SeSacFindViewController: UIViewController {
    
    private let mainView = SeSacFindView()
    private let disposeBag = DisposeBag()
    
    private let nearVC = NearSeSacViewController()
    private let recivedVC = RecivedViewController()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPagingButton()
        setButton()
        
        DispatchQueue.main.async {
            self.nearViewButtonClicked()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor().black
        self.navigationItem.title = "새싹 찾기"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(findStopButtonClicked))
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = UIColor().black
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func setPagingButton() {
        mainView.nearViewButton.rx.tap
            .scan(mainView.nearViewButton.status) { lastState, newState in
                self.mainView.recivedViewButton.status = .inactive
                self.nearViewButtonClicked()
                return .outline
            }
            .map{ $0 }
            .bind(to: mainView.nearViewButton.rx.status)
            .disposed(by: disposeBag)
        
        mainView.nearViewButton.rx.tap
            .scan(mainView.nearViewLine.status) { lastState, newState in
                self.mainView.recivedViewLine.status = .inactive
                return .fill
            }
            .map{ $0 }
            .bind(to: mainView.nearViewLine.rx.status)
            .disposed(by: disposeBag)
        
        mainView.recivedViewButton.rx.tap
            .scan(mainView.recivedViewButton.status) { lastState, newState in
                self.mainView.nearViewButton.status = .inactive
                self.recivedButtonClicked()
                return .outline
            }
            .map{ $0 }
            .bind(to: mainView.recivedViewButton.rx.status)
            .disposed(by: disposeBag)
        
        mainView.recivedViewButton.rx.tap
            .scan(mainView.recivedViewLine.status) { lastState, newState in
                self.mainView.nearViewLine.status = .inactive
                return .fill
            }
            .map{ $0 }
            .bind(to: mainView.recivedViewLine.rx.status)
            .disposed(by: disposeBag)

    }
    
    private func nearViewButtonClicked() {
        print(#function)
        if mainView.contentView.subviews.count > 0 {
            print("remove")
            self.recivedVC.view.removeFromSuperview()
            self.recivedVC.removeFromParent()
        }
        nearVC.view.frame = mainView.contentView.bounds
        mainView.contentView.addSubview(nearVC.view)
        self.addChild(nearVC)
        nearVC.didMove(toParent: self)
        
        self.reloadInputViews()
    }
    
    private func recivedButtonClicked() {
        print(#function)
        if mainView.contentView.subviews.count > 0 {
            print("remove")
            self.nearVC.view.removeFromSuperview()
            self.nearVC.removeFromParent()
        }
        print(mainView.contentView.frame)
        print(mainView.contentView.bounds)
        recivedVC.view.frame = mainView.contentView.bounds
        mainView.contentView.addSubview(recivedVC.view)
        self.addChild(recivedVC)
        recivedVC.didMove(toParent: self)
        
        self.reloadInputViews()
    }
    
    private func setButton() {
        mainView.hobbyChangeButton.rx.tap
            .bind {
                print("hobbyChange")
            }.disposed(by: disposeBag)
        
        mainView.resetButton.rx.tap
            .bind {
                print("Reset")
            }.disposed(by: disposeBag)
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
            print("\(sender.selectedSegmentIndex)")
    }
    
    @objc private func findStopButtonClicked() {
        print(#function)
    }

    

}




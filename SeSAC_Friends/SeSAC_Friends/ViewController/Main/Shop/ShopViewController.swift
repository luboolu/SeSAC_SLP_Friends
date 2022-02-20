//
//  ShopViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/26.
//

import UIKit

import RxCocoa
import RxSwift

final class ShopViewController: UIViewController {
    
    private let mainView = ShopView()
    private let disposeBag = DisposeBag()

    private var characterVC = CharacterShopViewController()
    private var backgroundVC = BackgroundShopViewController()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPagingButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor().black
        self.navigationController?.navigationBar.topItem?.title = "새싹샵"
        
        DispatchQueue.main.async {
            self.characterViewButtonClicked()
        }
    }
    
    private func setPagingButton() {
        mainView.characterViewButton.rx.tap
            .scan(mainView.characterViewButton.status) { lastState, newState in
                self.mainView.backgroundViewButton.status = .inactive
                self.characterViewButtonClicked()
                return .outline
            }
            .map{ $0 }
            .bind(to: mainView.characterViewButton.rx.status)
            .disposed(by: disposeBag)
        
        mainView.characterViewButton.rx.tap
            .scan(mainView.characterViewButtonLine.status) { lastState, newState in
                self.mainView.backgroundViewButtonLine.status = .inactive
                return .fill
            }
            .map{ $0 }
            .bind(to: mainView.characterViewButtonLine.rx.status)
            .disposed(by: disposeBag)
        
        mainView.backgroundViewButton.rx.tap
            .scan(mainView.backgroundViewButton.status) { lastState, newState in
                self.mainView.characterViewButton.status = .inactive
                self.backgroundViewButtonClicked()
                return .outline
            }
            .map{ $0 }
            .bind(to: mainView.backgroundViewButton.rx.status)
            .disposed(by: disposeBag)
        
        mainView.backgroundViewButton.rx.tap
            .scan(mainView.backgroundViewButtonLine.status) { lastState, newState in
                self.mainView.characterViewButtonLine.status = .inactive
                return .fill
            }
            .map{ $0 }
            .bind(to: mainView.backgroundViewButtonLine.rx.status)
            .disposed(by: disposeBag)
    }
    
    private func characterViewButtonClicked() {
        print(#function)
        if mainView.contentView.subviews.count > 0 {
            print(mainView.contentView.subviews)
            print("remove")
            self.characterVC.view.removeFromSuperview()
            self.characterVC.removeFromParent()
            
            self.backgroundVC.view.removeFromSuperview()
            self.backgroundVC.removeFromParent()
        }
        
        characterVC.view.frame = mainView.contentView.bounds
        mainView.contentView.addSubview(characterVC.view)
        self.addChild(characterVC)
        characterVC.didMove(toParent: self)
        
        self.reloadInputViews()
    }
    
    private func backgroundViewButtonClicked() {
        print(#function)
        if mainView.contentView.subviews.count > 0 {
            print(mainView.contentView.subviews)
            print("remove")
            self.characterVC.view.removeFromSuperview()
            self.characterVC.removeFromParent()
            
            self.backgroundVC.view.removeFromSuperview()
            self.backgroundVC.removeFromParent()
        }
        
        backgroundVC.view.frame = mainView.contentView.bounds
        mainView.contentView.addSubview(backgroundVC.view)
        self.addChild(backgroundVC)
        backgroundVC.didMove(toParent: self)
        
        self.reloadInputViews()
    }
}

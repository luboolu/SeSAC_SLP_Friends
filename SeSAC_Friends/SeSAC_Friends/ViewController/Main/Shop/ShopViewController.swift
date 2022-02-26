//
//  ShopViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/26.
//

import UIKit

import RxCocoa
import RxSwift
import Toast

final class ShopViewController: UIViewController {
    
    private let mainView = ShopView()
    private let viewModel = UserViewModel()
    private let disposeBag = DisposeBag()

    private var characterVC = CharacterShopViewController()
    private var backgroundVC = BackgroundShopViewController()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterViewRX()
        setPagingButton()
        setButton()
        DispatchQueue.main.async {
            self.characterViewButtonClicked()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor().black
        self.navigationItem.title = "새싹샵"
        
        DispatchQueue.main.async {
            self.characterViewButtonClicked()
            self.getUserInfo()
        }
    }
}

//character view setting 관련 extension
extension ShopViewController {
    
    private func characterViewRX() {

        UserDefaults.standard.rx
            .observe(Int.self, UserdefaultKey.shopCharacter.rawValue)
            .subscribe(onNext: { newValue in
                DispatchQueue.main.async {
                    self.mainView.charactorImage.image = UIImage(named: "sesac_face_\(newValue! + 1)")
                }
            })
            .disposed(by: disposeBag)
        
        UserDefaults.standard.rx
            .observe(Int.self, UserdefaultKey.shopBackground.rawValue)
            .subscribe(onNext: { newValue in
                DispatchQueue.main.async {
                    self.mainView.backgroundImage.image = UIImage(named: "sesac_background_\(newValue! + 1)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setButton() {
        mainView.saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
    }
    
    @objc private func saveButtonClicked() {
        print(#function)
        
        let character = UserDefaults.standard.integer(forKey: UserdefaultKey.shopCharacter.rawValue) ?? 0
        let background = UserDefaults.standard.integer(forKey: UserdefaultKey.shopBackground.rawValue) ?? 0
        
        viewModel.userUpdateShop(character: character, background: background) { apiResult, userUpdateShop in
            if let userUpdateShop = userUpdateShop {
                switch userUpdateShop {
                case .succeed:
                    print("업데이트 성공!")
                case .notPurchsed:
                    DispatchQueue.main.async {
                        self.view.makeToast("구매가 필요한 아이템이 있어요" ,duration: 2.0, position: .bottom, style: .defaultStyle)
                    }
                case .tokenError:
                    self.saveButtonClicked()
                    return
                case .notUser:
                    DispatchQueue.main.async {
                        //온보딩 화면으로 이동
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: OnBoardingViewController())
                        windowScene.windows.first?.makeKeyAndVisible()
                    }
                case .serverError:
                    DispatchQueue.main.async {
                        self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: .defaultStyle)
                    }
                case .clientError:
                    DispatchQueue.main.async {
                        self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: .defaultStyle)
                    }
                }
            }
        }
    }
}

//api 통신 관련 extension
extension ShopViewController {
    
    private func getUserInfo() {
        viewModel.getUser { apiResult, getUserResult, userInfo in
            if let getUserResult = getUserResult {
                switch getUserResult {
                case .existingUser:
                    if let userInfo = userInfo {
                        UserDefaults.standard.set(userInfo.background, forKey: UserdefaultKey.shopBackground.rawValue)
                        UserDefaults.standard.set(userInfo.sesac, forKey: UserdefaultKey.shopCharacter.rawValue)
                    }
                case .tokenError:
                    self.getUserInfo()
                    return
                case .newUser:
                    DispatchQueue.main.async {
                        //온보딩 화면으로 이동
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: OnBoardingViewController())
                        windowScene.windows.first?.makeKeyAndVisible()
                    }
                case .serverError:
                    DispatchQueue.main.async {
                        self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: .defaultStyle)
                    }
                case .clientError:
                    DispatchQueue.main.async {
                        self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: .defaultStyle)
                    }
                }
            }
        }
    }
    
}


//paging 관련 extension
extension ShopViewController {
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

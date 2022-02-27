//
//  genderViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/21.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import Toast

final class GenderViewController: UIViewController {
    
    private let viewModel = UserViewModel()
    private let mainView = GenderView()
    private let toastStyle = ToastStyle()
    private let disposeBag = DisposeBag()
    
    private var isMan = false
    private var isWoman = false
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = UIColor().black
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func setButton() {
        mainView.manButton.rx.tap
            .bind {
                self.isMan = !self.isMan

                if self.isMan {
                    self.isWoman = false
                    
                    self.mainView.womanButtonView.backgroundColor = UIColor().white
                    self.mainView.manButtonView.backgroundColor = UIColor().whitegreen
                } else {
                    self.isWoman = false
                    
                    self.mainView.manButtonView.backgroundColor = UIColor().white
                }
                
                if self.isMan == true || self.isWoman == true {
                    self.mainView.nextButton.status = .fill
                } else {
                    self.mainView.nextButton.status = .disable
                }
                
                print("man: \(self.isMan) woman: \(self.isWoman)")
            }.disposed(by: disposeBag)
        
        mainView.womanButton.rx.tap
            .bind {
                self.isWoman = !self.isWoman

                if self.isWoman {
                    self.isMan = false
                    
                    self.mainView.womanButtonView.backgroundColor = UIColor().whitegreen
                    self.mainView.manButtonView.backgroundColor = UIColor().white
                } else {
                    self.isMan = false
                    
                    self.mainView.womanButtonView.backgroundColor = UIColor().white
                }
                
                if self.isMan == true || self.isWoman == true {
                    self.mainView.nextButton.status = .fill
                } else {
                    self.mainView.nextButton.status = .disable
                }
                
                print("man: \(self.isMan) woman: \(self.isWoman)")
            }.disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .bind {
                //여자:0, 남자:1, 미선택: -1
                if self.isWoman == true {
                    //여자
                    UserDefaults.standard.set(0, forKey: UserdefaultKey.gender.rawValue)
                } else if self.isMan == true {
                    //남자
                    UserDefaults.standard.set(1, forKey: UserdefaultKey.gender.rawValue)
                } else {
                    //미선택
                    UserDefaults.standard.set(-1, forKey: UserdefaultKey.gender.rawValue)
                }
                self.signInRequest() //회원가입 요청
            }.disposed(by: disposeBag)
        
    }
    
    private func signInRequest() {
        //회원가입 api 통신 시작!
        self.viewModel.signIn { apiResult, signInResult in
            print("회원가입 완료 \(signInResult)")
            
            if signInResult == .succeed || signInResult == .alreadyProcessed {
                DispatchQueue.main.async {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: MainViewController())
                    windowScene.windows.first?.makeKeyAndVisible()
                }
                
            } else if signInResult == .invalidNickname {
                //닉네임 입력 화면으로 전환
                DispatchQueue.main.async {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: NicknameViewController())
                    windowScene.windows.first?.makeKeyAndVisible()
                }
            } else {
                self.view.makeToast("에러가 발생했습니다" ,duration: 2.0, position: .bottom, style: self.toastStyle)
            }
            
        }
    }
    
}

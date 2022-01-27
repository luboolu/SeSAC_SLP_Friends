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

class GenderViewController: UIViewController {
    
    let viewModel = AuthorizationViewModel()
    let mainView = GenderView()
    
    var isMan = false
    var isWoman = false
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setButton()
    }

    func setButton() {
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
            }
        
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
            }
        
        mainView.nextButton.rx.tap
            .bind {
                //여자:0, 남자:1, 미선택: -1
                if self.isWoman == true {
                    //여자
                    UserDefaults.standard.set(0, forKey: UserdefaultKey.gender.string)
                } else if self.isMan == true {
                    //남자
                    UserDefaults.standard.set(1, forKey: UserdefaultKey.gender.string)
                } else {
                    //미선택
                    UserDefaults.standard.set(-1, forKey: UserdefaultKey.gender.string)
                }
                
                //회원가입 api 통신 시작!
                self.viewModel.signIn { statusCode in
                    print("회원가입 완료")
                    
                    if statusCode == 200 {
                        
                        DispatchQueue.main.async {
                            
                            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                            windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: MainViewController())
                            windowScene.windows.first?.makeKeyAndVisible()
                        }
                        
                    } else if statusCode == 201 {
                        
                    } else if statusCode == 202 {
                        
                    } else if statusCode == 401 {
                        
                    } else if statusCode == 500 {
                        
                    } else if statusCode == 501 {
                        
                    } else {
                        
                    }
                    
                }
                
            }
        
    }
    
}

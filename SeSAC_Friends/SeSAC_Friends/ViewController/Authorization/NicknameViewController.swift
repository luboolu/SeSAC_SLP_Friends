//
//  NicknameViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/21.
//

import UIKit

import RxCocoa
import RxSwift
import Toast

final class NicknameViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let toastStyle = ToastStyle()
    private let mainView = NicknameView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextField()
        setButton()
        initializeKeyboard()
        //화면 진입 시 키보드가 활성화되도록 textfield를 firstresponder로 설정
        mainView.nicknameTextField.textfield.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = UIColor().black
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    
    private func setTextField() {
        
        mainView.nicknameTextField.textfield.rx.text
            .subscribe(onNext: { newValue in
                let result = self.trimString(newValue ?? "")
                self.mainView.nicknameTextField.textfield.text = result
                
                if result.count > 0 {
                    self.mainView.nextButton.status = .fill
                } else {
                    self.mainView.nextButton.status = .disable
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    private func setButton() {
        
        mainView.nextButton.rx.tap
            .bind {
                print("nextButtonTapped")
                self.nextButtonTapped()
            }
        
    }
    
    private func nextButtonTapped() {
        //입력된 닉네임이 1~10자 내인지 확인
        let input = mainView.nicknameTextField.textfield.text!
        
        if input.count > 0 {
            //UserDefault에 저장
            UserDefaults.standard.set(input, forKey: UserdefaultKey.nickname.rawValue)
            
            let vc = BirthViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            self.view.makeToast("닉네임은 1자 이상 10자 이내로 부탁드려요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
        }
    }
    
    
    private func trimString(_ str: String) -> String {
        
        var result = ""

        //6자리 넘게 입력되지 않도록 함
        if str.count > 10 {
            let index = str.index(str.startIndex, offsetBy: 10)
            result = String(str[..<index])
            
            return result
        }
        return str
    }
}

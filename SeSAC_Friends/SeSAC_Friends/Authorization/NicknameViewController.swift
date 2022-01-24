//
//  NicknameViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/21.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import Toast

class NicknameViewController: UIViewController {
    
    let guideLabel1: UILabel = {
        let label = UILabel()
        
        label.text = "닉네임을 입력해주세요"
        label.textColor = UIColor().black
        label.font = UIFont().Display1_R20
        label.textAlignment = .center
        
        return label
    }()
    
    let nicknameTextField = MainTextFieldView()
    let nextButton = MainButton(status: .disable)
    
    let disposeBag = DisposeBag()
    let toastStyle = ToastStyle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setConstraints()
        setTextField()
        setButton()
        
        //화면 진입 시 키보드가 활성화되도록 textfield를 firstresponder로 설정
        nicknameTextField.textfield.becomeFirstResponder()
    }
    
    func setUp() {
        view.backgroundColor = UIColor().white
        view.addSubview(guideLabel1)
        
        nicknameTextField.status = .inactive
        nicknameTextField.textfield.placeholder = "10자 이내로 입력"
        view.addSubview(nicknameTextField)
        
        nextButton.setTitle("다음", for: .normal)
        view.addSubview(nextButton)
    }
    
    func setConstraints() {
        guideLabel1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.centerX.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(guideLabel1.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }
    
    func setTextField() {
        
        nicknameTextField.textfield.rx.text
            .subscribe(onNext: { newValue in
                let result = self.trimString(newValue ?? "")
                self.nicknameTextField.textfield.text = result
                
                if result.count > 0 {
                    self.nextButton.status = .fill
                } else {
                    self.nextButton.status = .disable
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    func setButton() {
        
        nextButton.rx.tap
            .bind {
                print("nextButtonTapped")
                self.nextButtonTapped()
            }
        
    }
    
    func nextButtonTapped() {
        //입력된 닉네임이 1~10자 내인지 확인
        let input = nicknameTextField.textfield.text!
        
        if input.count > 0 {
            //UserDefault에 저장
            UserDefaults.standard.set(input, forKey: UserdefaultKey.nickname.string)
            
            let vc = BirthViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            self.view.makeToast("닉네임은 1자 이상 10자 이내로 부탁드려요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
        }
    }
    
    
    func trimString(_ str: String) -> String {
        
        var result = ""

        //6자리 넘게 입력되지 않도록 함
        if str.count > 10 {
            let index = str.index(str.startIndex, offsetBy: 10)
            //self.authCodeTextField.textfield.text = String(number[..<index])
            result = String(str[..<index])
            
            return result
        }
        
        return str
        
    }
}

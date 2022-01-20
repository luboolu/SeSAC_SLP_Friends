//
//  PhoneNumberAuthInputViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/21.
//

import UIKit

import FirebaseAuth
import SnapKit

class LoginConfirmViewController: UIViewController {
    
    let guideLabel1: UILabel = {
        let label = UILabel()
        
        label.text = "인증번호가 문자로 전송되었습니다"
        label.textColor = UIColor().black
        label.font = UIFont().Display1_R20
        label.textAlignment = .center
        
        return label
    }()
    
    let guideLabel2: UILabel = {
        let label = UILabel()
        
        label.text = "최대 소모 20초"
        label.textColor = UIColor().gray7
        label.font = UIFont().Title2_R16
        label.textAlignment = .center
        
        return label
    }()
    
    let authCodeTextField = MainTextFieldView()
    
    let resendAuthButton = MainButton(status: .fill)
    
    let authButton = MainButton(status: .disable)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setConstraints()
    }
    
    func setUp() {
        view.backgroundColor = UIColor().white
        
        view.addSubview(guideLabel1)
        view.addSubview(guideLabel2)
        
        authCodeTextField.status = .inactive
        authCodeTextField.textfield.placeholder = "인증번호 입력"
        authCodeTextField.textfield.keyboardType = .numberPad
        view.addSubview(authCodeTextField)
        
        resendAuthButton.setTitle("재전송", for: .normal)
        view.addSubview(resendAuthButton)
        
        authButton.setTitle("인증하고 시작하기", for: .normal)
        view.addSubview(authButton)
    }
    
    func setConstraints() {
        guideLabel1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(160)
            make.centerX.equalToSuperview()
        }
        
        guideLabel2.snp.makeConstraints { make in
            make.top.equalTo(guideLabel1.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        authCodeTextField.snp.makeConstraints { make in
            make.top.equalTo(guideLabel2.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(resendAuthButton.snp.leading).offset(-8)
        }
        
        resendAuthButton.snp.makeConstraints { make in
            make.top.equalTo(guideLabel2.snp.bottom).offset(70)
            make.leading.equalTo(authCodeTextField.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.width.equalTo(72)
            make.height.equalTo(40)
        }
        
        authButton.snp.makeConstraints { make in
            make.top.equalTo(authCodeTextField.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }
    
}

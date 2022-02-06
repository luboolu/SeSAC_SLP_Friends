//
//  LoginConfirmView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/27.
//

import UIKit

import SnapKit

final class LoginConfirmView: UIView, ViewRepresentable {
    
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
    
    let authValidTime: UILabel = {
        let label = UILabel()
        
        label.text = "01:00"
        label.textColor = UIColor().green
        label.font = UIFont().Title3_M14
        
        return label
    }()
    
    let resendAuthButton: MainButton = {
        let button = MainButton()
        
        button.status = .fill
        button.isBorder = true
        button.isRounded = true
        
        return button
    }()
    
    let authButton: MainButton = {
        let button = MainButton()
        
        button.status = .disable
        button.isBorder = true
        button.isRounded = true
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func setupView() {
        self.backgroundColor = UIColor().white
        
        self.addSubview(guideLabel1)
        self.addSubview(guideLabel2)
        
        authCodeTextField.status = .inactive
        authCodeTextField.textfield.placeholder = "인증번호 입력"
        authCodeTextField.textfield.keyboardType = .numberPad
        self.addSubview(authCodeTextField)
        
        resendAuthButton.setTitle("재전송", for: .normal)
        self.addSubview(resendAuthButton)
        
        self.addSubview(authValidTime)
        
        authButton.setTitle("인증하고 시작하기", for: .normal)
        self.addSubview(authButton)
    }
    
    func setupConstraints() {
        guideLabel1.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(160)
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
        
        authValidTime.snp.makeConstraints { make in
            make.centerY.equalTo(resendAuthButton)
            make.trailing.equalTo(resendAuthButton.snp.leading).offset(-20)
        }
        
        authButton.snp.makeConstraints { make in
            make.top.equalTo(authCodeTextField.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }
    
    
}

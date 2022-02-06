//
//  LoginView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/27.
//

import UIKit

import SnapKit

final class LoginView: UIView, ViewRepresentable {
    
    let guideLabel: UILabel = {
        let label = UILabel()
        
        label.text = "새싹 서비스 이용을 위해 \n휴대폰 번호를 입력해주세요"
        label.textColor = UIColor().black
        label.font = UIFont().Display1_R20
        label.numberOfLines = 2
        label.textAlignment = .center
    
        
        return label
    }()
    
    let textfieldView = MainTextFieldView()
    let authMessageButton: MainButton = {
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
        
        self.addSubview(guideLabel)
        
        textfieldView.status = .inactive
        textfieldView.textfield.placeholder = "휴대폰 번호(- 없이 숫자만 입력)"
        textfieldView.textfield.keyboardType = .numberPad
        self.addSubview(textfieldView)
        
        authMessageButton.setTitle("인증 문자 받기", for: .normal)
        self.addSubview(authMessageButton)
        
    }
    
    func setupConstraints() {
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(160)
            make.centerX.equalToSuperview()
            
        }
        
        textfieldView.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        authMessageButton.snp.makeConstraints { make in
            make.top.equalTo(textfieldView.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }
}

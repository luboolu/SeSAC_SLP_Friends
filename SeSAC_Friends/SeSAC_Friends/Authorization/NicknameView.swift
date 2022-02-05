//
//  NicknameView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/27.
//

import UIKit

import SnapKit

final class NicknameView: UIView, ViewRepresentable {
    let guideLabel1: UILabel = {
        let label = UILabel()
        
        label.text = "닉네임을 입력해주세요"
        label.textColor = UIColor().black
        label.font = UIFont().Display1_R20
        label.textAlignment = .center
        
        return label
    }()
    
    let nicknameTextField = MainTextFieldView()
    let nextButton: MainButton = {
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
        
        nicknameTextField.status = .inactive
        nicknameTextField.textfield.placeholder = "10자 이내로 입력"
        self.addSubview(nicknameTextField)
        
        nextButton.setTitle("다음", for: .normal)
        self.addSubview(nextButton)
    }
    
    func setupConstraints() {
        guideLabel1.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(80)
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
}

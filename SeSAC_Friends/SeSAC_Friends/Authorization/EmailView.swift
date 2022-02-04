//
//  EmailView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/27.
//

import UIKit

import SnapKit

final class EmailView: UIView, ViewRepresentable {
    
    let guideLabel1: UILabel = {
        let label = UILabel()
        
        label.text = "이메일을 입력해주세요"
        label.textColor = UIColor().black
        label.font = UIFont().Display1_R20
        label.textAlignment = .center
        
        return label
    }()
    
    let guideLabel2: UILabel = {
        let label = UILabel()
        
        label.text = "휴대폰 번호 변경 시 인증을 위해 사용해요"
        label.textColor = UIColor().gray7
        label.font = UIFont().Title2_R16
        label.textAlignment = .center
        
        return label
    }()
    
    let emailTextField = MainTextFieldView()
    
    let nextButton = MainButton(status: .disable)
    
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
        
        emailTextField.status = .inactive
        emailTextField.textfield.placeholder = "SeSAC@email.com"
        self.addSubview(emailTextField)
        
        nextButton.setTitle("다음", for: .normal)
        self.addSubview(nextButton)
    }
    
    func setupConstraints() {
        guideLabel1.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(80)
            make.centerX.equalToSuperview()
        }
        
        guideLabel2.snp.makeConstraints { make in
            make.top.equalTo(guideLabel1.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(guideLabel2.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }
}

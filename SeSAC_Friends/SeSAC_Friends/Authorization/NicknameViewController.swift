//
//  NicknameViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/21.
//

import UIKit

import SnapKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setConstraints()
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
}

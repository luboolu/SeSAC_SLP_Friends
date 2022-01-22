//
//  emailViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/21.
//

import UIKit

import SnapKit

class emailViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setConstraints()
        
    }
    
    func setUp() {
        view.backgroundColor = UIColor().white
        
        view.addSubview(guideLabel1)
        view.addSubview(guideLabel2)
        
        emailTextField.status = .inactive
        emailTextField.textfield.placeholder = "SeSAC@email.com"
        view.addSubview(emailTextField)
        
        nextButton.setTitle("다음", for: .normal)
        view.addSubview(nextButton)
    }
    
    func setConstraints() {
        
        guideLabel1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
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

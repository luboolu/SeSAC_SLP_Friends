//
//  PhoneNumberAuthViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/19.
//

import UIKit

import SnapKit

class PhoneNumberAuthViewController: UIViewController {
    
    let textfieldView = MainTextFieldView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUp()
        setConstraints()
        
        //numberTextField.backgroundColor = UIColor().white
        textfieldView.status = .disable
    }
    
    func setUp() {
        view.backgroundColor = UIColor().white
        
        view.addSubview(textfieldView)
        
//        let bottomLine = CALayer()
//        bottomLine.frame = CGRect(x: 0.0, y: 75 - 1, width: 300, height: 1.0)
//        bottomLine.backgroundColor = UIColor().error.cgColor
//        numberTextField.borderStyle = .none
//        numberTextField.layer.addSublayer(bottomLine)
    }
    
    func setConstraints() {
        textfieldView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(66)
        }
        

    }
}

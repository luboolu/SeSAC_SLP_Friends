//
//  MainTextFieldTestViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/19.
//
import UIKit

import SnapKit

class MainTextFieldTestViewController: UIViewController {
    
    let textfieldView1 = MainTextFieldView()
    let textfieldView2 = MainTextFieldView()
    let textfieldView3 = MainTextFieldView()
    let textfieldView4 = MainTextFieldView()
    let textfieldView5 = MainTextFieldView()
    let textfieldView6 = MainTextFieldView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setConstraints()
        
    }
    
    func setUp() {
        view.backgroundColor = UIColor().white
        
        textfieldView1.status = .inactive
        textfieldView2.status = .focus
        textfieldView3.status = .active
        textfieldView4.status = .disable
        textfieldView5.status = .error
        textfieldView6.status = .success
        

        
        view.addSubview(textfieldView1)
        view.addSubview(textfieldView2)
        view.addSubview(textfieldView3)
        view.addSubview(textfieldView4)
        view.addSubview(textfieldView5)
        view.addSubview(textfieldView6)
        


    }
    
    func setConstraints() {
        textfieldView1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            //make.height.equalTo(77)
        }
        
        textfieldView2.snp.makeConstraints { make in
            make.top.equalTo(textfieldView1.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            //make.height.equalTo(77)
        }
        
        textfieldView3.snp.makeConstraints { make in
            make.top.equalTo(textfieldView2.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            //make.height.equalTo(77)
        }
        
        textfieldView4.snp.makeConstraints { make in
            make.top.equalTo(textfieldView3.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            //make.height.equalTo(77)
        }
        
        textfieldView5.snp.makeConstraints { make in
            make.top.equalTo(textfieldView4.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            //make.height.equalTo(77)
        }
        
        textfieldView6.snp.makeConstraints { make in
            make.top.equalTo(textfieldView5.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            //make.height.equalTo(77)
        }
        

    }
}

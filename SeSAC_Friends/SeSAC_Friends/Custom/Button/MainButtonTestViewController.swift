//
//  MainButtonTestViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/19.
//

import UIKit

import SnapKit

class MainButtonTestViewController: UIViewController {
    
    let mainButton1 = MainButton()
    let mainButton2 = MainButton()
    let mainButton3 = MainButton()
    let mainButton4 = MainButton()
    let mainButton5 = MainButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setConstraints()
    }
    
    func setUp() {
        view.backgroundColor = UIColor().white
        
        view.addSubview(mainButton1)
        view.addSubview(mainButton2)
        view.addSubview(mainButton3)
        view.addSubview(mainButton4)
        view.addSubview(mainButton5)
        
        mainButton1.status = .inactive
        mainButton1.setTitle("버튼 내용", for: .normal)
        
        mainButton2.status = .fill
        mainButton2.setTitle("버튼 내용", for: .normal)
        
        mainButton3.status = .outline
        mainButton3.setTitle("버튼 내용", for: .normal)
        
        mainButton4.status = .cancel
        mainButton4.setTitle("버튼 내용", for: .normal)
        
        mainButton5.status = .disable
        mainButton5.setTitle("버튼 내용", for: .normal)
    }
    
    func setConstraints() {
        mainButton1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(48)
        }
        
        mainButton2.snp.makeConstraints { make in
            make.top.equalTo(mainButton1.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(48)
        }
        
        mainButton3.snp.makeConstraints { make in
            make.top.equalTo(mainButton2.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(48)
        }
        
        mainButton4.snp.makeConstraints { make in
            make.top.equalTo(mainButton3.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(48)
        }
        
        mainButton5.snp.makeConstraints { make in
            make.top.equalTo(mainButton4.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(48)
        }
    }
}

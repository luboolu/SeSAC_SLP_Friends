//
//  BirthViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/21.
//

import UIKit

import SnapKit

class BirthViewController: UIViewController {
    
    let guideLabel1: UILabel = {
        let label = UILabel()
        
        label.text = "생년월일을 알려주세요"
        label.textColor = UIColor().black
        label.font = UIFont().Display1_R20
        label.textAlignment = .center
        
        return label
    }()
    
    let yearTextField = MainTextFieldView()
    let yearLabel: UILabel = {
        let label = UILabel()
        
        label.text = "년"
        label.textColor = UIColor().black
        label.font = UIFont().Title2_R16
        label.textAlignment = .center
        
        return label
    }()
    
    let monthTextField = MainTextFieldView()
    let monthLabel: UILabel = {
        let label = UILabel()
        
        label.text = "월"
        label.textColor = UIColor().black
        label.font = UIFont().Title2_R16
        label.textAlignment = .center
        
        return label
    }()
    
    let dayTextField = MainTextFieldView()
    let dayLabel: UILabel = {
        let label = UILabel()
        
        label.text = "일"
        label.textColor = UIColor().black
        label.font = UIFont().Title2_R16
        label.textAlignment = .center
        
        return label
    }()
    
    let stackview: UIStackView = {
        let stackview = UIStackView()
        
        stackview.axis = .horizontal
        stackview.spacing = 0
        stackview.distribution = .fillEqually
        stackview.alignment = .center
        
        return stackview
    }()
    
    let nextButton = MainButton(status: .disable)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setConstraints()
    }
    
    func setUp() {
        view.backgroundColor = UIColor().white
        
        view.addSubview(guideLabel1)
        
        yearTextField.status = .inactive
        yearTextField.textfield.placeholder = ""
        stackview.addArrangedSubview(yearTextField)
        stackview.addArrangedSubview(yearLabel)
        
        monthTextField.status = .inactive
        monthTextField.textfield.placeholder = ""
        stackview.addArrangedSubview(monthTextField)
        stackview.addArrangedSubview(monthLabel)
        
        dayTextField.status = .inactive
        dayTextField.textfield.placeholder = ""
        stackview.addArrangedSubview(dayTextField)
        stackview.addArrangedSubview(dayLabel)
       
        view.addSubview(stackview)
        
        nextButton.setTitle("다음", for: .normal)
        view.addSubview(nextButton)
    }
    
    func setConstraints() {
        guideLabel1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.centerX.equalToSuperview()
        }
        
        stackview.snp.makeConstraints { make in
            make.top.equalTo(guideLabel1.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        nextButton.snp.makeConstraints { make in
            make.top.equalTo(stackview.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }
}

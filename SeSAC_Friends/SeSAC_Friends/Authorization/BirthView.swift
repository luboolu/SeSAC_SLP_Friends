//
//  BirthView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/27.
//

import UIKit

import SnapKit

final class BirthView: UIView, ViewRepresentable {
    
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
    
    let pickerView: UIDatePicker = {
        let picker = UIDatePicker()
        
        //UIDatePicker(frame: CGRect(x: 200, y: 0, width: UIScreen.main.bounds.width, height: 200))
        picker.locale = Locale(identifier: "ko")
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        
        return picker
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
        
        yearTextField.status = .inactive
        yearTextField.textfield.placeholder = ""
        yearTextField.textfield.textAlignment = .center
        stackview.addArrangedSubview(yearTextField)
        stackview.addArrangedSubview(yearLabel)
        
        monthTextField.status = .inactive
        monthTextField.textfield.placeholder = ""
        monthTextField.textfield.textAlignment = .center
        stackview.addArrangedSubview(monthTextField)
        stackview.addArrangedSubview(monthLabel)
        
        dayTextField.status = .inactive
        dayTextField.textfield.placeholder = ""
        dayTextField.textfield.textAlignment = .center
        stackview.addArrangedSubview(dayTextField)
        stackview.addArrangedSubview(dayLabel)
       
        self.addSubview(stackview)
        
        nextButton.setTitle("다음", for: .normal)
        self.addSubview(nextButton)
        
        yearTextField.textfield.inputView = pickerView
        monthTextField.textfield.inputView = pickerView
        dayTextField.textfield.inputView = pickerView
    }
    
    func setupConstraints() {
        guideLabel1.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(80)
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

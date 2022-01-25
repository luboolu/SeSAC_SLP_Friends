//
//  BirthViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/21.
//

import UIKit

import SnapKit
import RxSwift
import Toast

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
    
    let pickerView: UIDatePicker = {
        let picker = UIDatePicker()
        
        //UIDatePicker(frame: CGRect(x: 200, y: 0, width: UIScreen.main.bounds.width, height: 200))
        picker.locale = Locale(identifier: "ko")
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        
        return picker
    }()
    
    let disposeBag = DisposeBag()
    let toastStyle = ToastStyle()
    
    var birthDay: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setConstraints()
        setTextField()
        setButton()
        createPickerView()
    }
    
    func setUp() {
        view.backgroundColor = UIColor().white
        
        view.addSubview(guideLabel1)
        
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
    
    func setTextField() {
        
        
        
    }
    
    func setButton() {
        
        nextButton.rx.tap
            .bind {
                self.nextButtonTapped()
            }
        
    }
    
    func createPickerView() {

        yearTextField.textfield.inputView = pickerView
        monthTextField.textfield.inputView = pickerView
        dayTextField.textfield.inputView = pickerView
        
        
        
        pickerView.rx.date
            .subscribe(onNext: { newValue in
                print(newValue)
                
                let yearFormat = DateFormatter()
                yearFormat.locale = Locale(identifier: "ko")
                yearFormat.dateFormat = "yyyy"
                
                let monthFormat = DateFormatter()
                monthFormat.locale = Locale(identifier: "ko")
                monthFormat.dateFormat = "MM"
                
                let dayFormat = DateFormatter()
                dayFormat.locale = Locale(identifier: "ko")
                dayFormat.dateFormat = "dd"
                
                let year = yearFormat.string(from: newValue)
                let month = monthFormat.string(from: newValue)
                let day = dayFormat.string(from: newValue)
                
                print("formatted: \(year) \(month) \(day)")
                
                self.yearTextField.textfield.text = "\(year)"
                self.monthTextField.textfield.text = "\(month)"
                self.dayTextField.textfield.text = "\(day)"
                
                self.birthDay = newValue
                
                
            })
            .disposed(by: disposeBag)
        
        
        yearTextField.textfield.becomeFirstResponder()
    }
    
    func trimTextField(_ number: String) -> String {
        
        var result = ""

        if number.count > 0 {
            var trimNum = number
            let lastInput = String(trimNum.removeLast())
            //print("number: \(number) trimNum: \(trimNum) last: \(lastInput)")

            if Int(lastInput) != nil {
                //self.authCodeTextField.textfield.text = number
                result = number
            } else {
                //self.authCodeTextField.textfield.text = trimNum
                result = trimNum
            }
         }

        //6자리 넘게 입력되지 않도록 함
        if number.count > 6 {
            let index = number.index(number.startIndex, offsetBy: 6)
            //self.authCodeTextField.textfield.text = String(number[..<index])
            result = String(number[..<index])
        }
        
        return result
    }
    
    func nextButtonTapped() {
        self.view.endEditing(true)
        //만 17세 이상인지 확인
        let today = Date.now

        guard let distance = Calendar.current.dateComponents([.day], from: self.birthDay ?? today, to: today).day else {
            return
        }
        
        print(distance)
        
        if distance < 365 * 17 {
            self.view.makeToast("새싹친구는 만 17세 이상만 사용할 수 있습니다" ,duration: 2.0, position: .bottom, style: self.toastStyle)
        } else {
            //조건에 부합하므로 생년월일 정보를 userdefault에 저장
            guard let formatted = self.birthDay?.ISO8601Format() else {
                return
            }
            UserDefaults.standard.set(formatted, forKey: UserdefaultKey.birthDay.string)
            
            let vc = EmailViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }

}






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

final class BirthViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let toastStyle = ToastStyle()
    private let mainView = BirthView()
    
    private var birthDay: Date?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButton()
        createPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = UIColor().black
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    private func setButton() {
        mainView.nextButton.rx.tap
            .bind {
                self.nextButtonTapped()
            }.disposed(by: disposeBag)
    }
    
    private func createPickerView() {
        mainView.pickerView.rx.date
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
                
                self.mainView.yearTextField.textfield.text = "\(year)"
                self.mainView.monthTextField.textfield.text = "\(month)"
                self.mainView.dayTextField.textfield.text = "\(day)"
                
                self.birthDay = newValue
            })
            .disposed(by: disposeBag)
        
        mainView.yearTextField.textfield.becomeFirstResponder()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPickerView))
        view.addGestureRecognizer(tap)
    }
    
    private func nextButtonTapped() {
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
            UserDefaults.standard.set(formatted, forKey: UserdefaultKey.birthDay.rawValue)
            
            let vc = EmailViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func dismissPickerView() {
        print(#function)
        mainView.yearTextField.textfield.resignFirstResponder()
        mainView.monthTextField.textfield.resignFirstResponder()
        mainView.dayTextField.textfield.resignFirstResponder()
    }

}






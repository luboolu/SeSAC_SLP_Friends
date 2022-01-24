//
//  emailViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/21.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Toast

class EmailViewController: UIViewController {
    
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
    
    let toastStyle = ToastStyle()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setConstraints()
        setTextField()
        setButton()
        
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
    
    func setTextField() {
        
        emailTextField.textfield.rx.text
            .subscribe(onNext: { newValue in
                
                if newValue?.count ?? 0 > 0 {
                    self.nextButton.status = .fill
                } else {
                    self.nextButton.status = .disable
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    func setButton() {
        
        nextButton.rx.tap
            .bind {
                self.nextButtonTapped()
            }
        
    }
    
    func nextButtonTapped() {

        let input = emailTextField.textfield.text ?? ""
        
        if isValidEmail(email: input) {
            UserDefaults.standard.set(input, forKey: UserdefaultKey.email.string)
            
            let vc = GenderViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.view.makeToast("이메일 형식이 올바르지 않습니다" ,duration: 2.0, position: .bottom, style: self.toastStyle)
        }
        
    }
    
    func isValidEmail(email: String?) -> Bool {
        guard email != nil else { return false}
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let pred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return pred.evaluate(with: email)
    }
    
    
}

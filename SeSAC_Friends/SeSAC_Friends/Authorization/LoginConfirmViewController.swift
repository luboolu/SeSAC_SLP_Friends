//
//  PhoneNumberAuthInputViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/21.
//

import UIKit

import FirebaseAuth
import SnapKit
import RxSwift
import RxCocoa

class LoginConfirmViewController: UIViewController {
    
    var authCode: String?
    
    let guideLabel1: UILabel = {
        let label = UILabel()
        
        label.text = "인증번호가 문자로 전송되었습니다"
        label.textColor = UIColor().black
        label.font = UIFont().Display1_R20
        label.textAlignment = .center
        
        return label
    }()
    
    let guideLabel2: UILabel = {
        let label = UILabel()
        
        label.text = "최대 소모 20초"
        label.textColor = UIColor().gray7
        label.font = UIFont().Title2_R16
        label.textAlignment = .center
        
        return label
    }()
    
    let authCodeTextField = MainTextFieldView()
    
    let authValidTime: UILabel = {
        let label = UILabel()
        
        label.text = "05:00"
        label.textColor = UIColor().green
        label.font = UIFont().Title3_M14
        
        return label
    }()
    
    var timer: Timer?
    var timerNum: Int = 299
    
    let resendAuthButton = MainButton(status: .fill)
    
    let authButton = MainButton(status: .disable)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setConstraints()
        startTimer()
        setTextFieldRx()
        setButton()
    }
    
    func setUp() {
        view.backgroundColor = UIColor().white
        
        view.addSubview(guideLabel1)
        view.addSubview(guideLabel2)
        
        authCodeTextField.status = .inactive
        authCodeTextField.textfield.placeholder = "인증번호 입력"
        authCodeTextField.textfield.keyboardType = .numberPad
        view.addSubview(authCodeTextField)
        
        resendAuthButton.setTitle("재전송", for: .normal)
        view.addSubview(resendAuthButton)
        
        view.addSubview(authValidTime)
        
        authButton.setTitle("인증하고 시작하기", for: .normal)
        view.addSubview(authButton)
    }
    
    func setConstraints() {
        guideLabel1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(160)
            make.centerX.equalToSuperview()
        }
        
        guideLabel2.snp.makeConstraints { make in
            make.top.equalTo(guideLabel1.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        authCodeTextField.snp.makeConstraints { make in
            make.top.equalTo(guideLabel2.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(resendAuthButton.snp.leading).offset(-8)
        }
        
        resendAuthButton.snp.makeConstraints { make in
            make.top.equalTo(guideLabel2.snp.bottom).offset(70)
            make.leading.equalTo(authCodeTextField.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.width.equalTo(72)
            make.height.equalTo(40)
        }
        
        authValidTime.snp.makeConstraints { make in
            make.centerY.equalTo(resendAuthButton)
            make.trailing.equalTo(resendAuthButton.snp.leading).offset(-20)
        }
        
        authButton.snp.makeConstraints { make in
            make.top.equalTo(authCodeTextField.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }
    
    func startTimer() {
        //기존에 타이머 동작중이면 중지 처리
        if timer != nil && timer!.isValid {
            timer!.invalidate()
        }
     
        //타이머 사용값 초기화
        timerNum = 300
        //1초 간격 타이머 시작
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)

    }
    
    func setTextFieldRx() {
        
        authCodeTextField.textfield.rx.text
            .subscribe(onNext: { newValue in
                self.trimNumber(newValue ?? "")
            }).disposed(by: disposeBag)
        
    }
    
    func setButton() {
        
        authButton.rx.tap
            .bind {
                print("auth button clicked!")
            }.disposed(by: disposeBag)
        
        resendAuthButton.rx.tap
            .bind {
                print("resentAuthButton clicked!")
                
                //timer 초기화
                self.startTimer()
                //firebase 인증 문자 재전송
                
            }.disposed(by: disposeBag)
        
    }
    
    func trimNumber(_ number: String) {

        if number.count > 0 {
            var trimNum = number
            let lastInput = String(trimNum.removeLast())
            //print("number: \(number) trimNum: \(trimNum) last: \(lastInput)")

            if Int(lastInput) != nil {
                self.authCodeTextField.textfield.text = number
            } else {
                self.authCodeTextField.textfield.text = trimNum
            }
         }

        //6자리 넘게 입력되지 않도록 함
        if number.count > 6 {
            let index = number.index(number.startIndex, offsetBy: 6)
            self.authCodeTextField.textfield.text = String(number[..<index])
        }
    }
    
    //타이머 동작 func
    @objc func timerCallback() {
        
        let minute = Int(timerNum / 60)
        let seconds = Int(timerNum % 60)
        
        if seconds < 10 {
            self.authValidTime.text = "0\(minute):0\(seconds)"
        } else {
            self.authValidTime.text = "0\(minute):\(seconds)"
        }
        
     
        //timerNum이 0이면(60초 경과) 타이머 종료
        if(timerNum == 0) {
            timer?.invalidate()
            timer = nil
            
            //타이머 종료 후 처리...
        }
     
        //timerNum -1 감소시키기
        timerNum -= 1
    }
    
}

//
//  PhoneNumberAuthViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/19.
//

import UIKit

import FirebaseAuth
import SnapKit
import RxSwift
import RxCocoa
import Toast


class LoginViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let tagGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    
    let guideLabel: UILabel = {
        let label = UILabel()
        
        label.text = "새싹 서비스 이용을 위해 \n휴대폰 번호를 입력해주세요"
        label.textColor = UIColor().black
        label.font = UIFont().Display1_R20
        label.numberOfLines = 2
        label.textAlignment = .center
    
        
        return label
    }()
    
    let textfieldView = MainTextFieldView()

    let authMessageButton = MainButton(status: .disable)
    
    var isNumberValid: Observable<Bool> = Observable<Bool>.just(false)
    var isValid = false
    
    let toastStyle = ToastStyle()
    
    let viewModel = AuthorizationViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagGesture.delegate = self
        self.view.addGestureRecognizer(tagGesture)
        
        print("authVerificationID")
        print(UserDefaults.standard.string(forKey: UserdefaultKey.authVerificationID.string) ?? "")
        
        print("idtoken")
        print(UserDefaults.standard.string(forKey: UserdefaultKey.idToken.string) ?? "")
        
        print("fcmToken")
        print(UserDefaults.standard.string(forKey: UserdefaultKey.fcmToken.string) ?? "")

        
        setUp()
        setConstraints()
        setButton()
        setTextFieldRx()
        
    }
    
    func setUp() {
        view.backgroundColor = UIColor().white
        
        view.addSubview(guideLabel)
        
        textfieldView.status = .inactive
        textfieldView.textfield.placeholder = "휴대폰 번호(- 없이 숫자만 입력)"
        textfieldView.textfield.keyboardType = .numberPad
        view.addSubview(textfieldView)
        
        authMessageButton.setTitle("인증 문자 받기", for: .normal)
        view.addSubview(authMessageButton)
        

    }
    
    func setConstraints() {
        
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(160)
            make.centerX.equalToSuperview()
            
        }
        
        textfieldView.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        authMessageButton.snp.makeConstraints { make in
            make.top.equalTo(textfieldView.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
        

    }
    
    func setButton() {
        //authMessageButton.addTarget(self, action: #selector(authMessageButtonClicked), for: .touchUpInside)
        
        authMessageButton.rx.tap
            .bind {
                print("button clicked")
                if self.isValid {
                    //토스트 알림 띄우기
                    self.view.makeToast("전화번호 인증 시작" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    
                    let number = "+82 \(self.textfieldView.textfield.text!)"
                    print(number)
                    
                    UserDefaults.standard.set(number, forKey: UserdefaultKey.phoneNumber.string)
                    //firebase auth 시작
                    
                    self.viewModel.authRequest(phoneNumber: number) { error in
                        if let error = error {
                            if error.localizedDescription == "We have blocked all requests from this device due to unusual activity. Try again later." {
                                self.view.makeToast("과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요." ,duration: 2.0, position: .bottom, style: self.toastStyle)
                            } else {
                                self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                            }
                        } else {
                            //전화번호 인증 문자 전송 성공 -> 인증번호 입력 화면으로 화면전환
                            let vc = LoginConfirmViewController()
        
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    }

                } else {
                    //토스트 알림 띄우기
                    self.view.makeToast("잘못된 전화번호 형식입니다" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                }
            }.disposed(by: disposeBag)
        
    }
    
    func setTextFieldRx() {
        //textfield rxswift 사용하기
        
        //textfield의 입력값이 바뀔때 마다 감지 -> 유효성 검사
        textfieldView.textfield.rx.text
            .subscribe(onNext: { newValue in
                self.trimNumber(newValue ?? "")
                print(newValue)
            }).disposed(by: disposeBag)
        
        //textfield가 활성화되는 시점을 감지
        textfieldView.textfield.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe(onNext: { _ in
                print("textfield editing start")
                self.textfieldView.status = .active
                self.textfieldView.textfield.placeholder = "휴대폰 번호(- 없이 숫자만 입력)"
            }).disposed(by: disposeBag)
        
        //textfield가 비활성화 되는 시점을 감지
        textfieldView.textfield.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: { _ in
                print("textfield editing end")
                self.textfieldView.status = .inactive
                self.textfieldView.textfield.placeholder = "휴대폰 번호(- 없이 숫자만 입력)"
            }).disposed(by: disposeBag)
        
        //number textfield 입력값 유효성 검사
        //휴대전화 번호 11자리 입력
        //숫자로 입력
        isNumberValid = textfieldView.textfield.rx.text
            .map { text -> Bool in
                return (text?.count == 13)
            }.distinctUntilChanged()
            
        
        isNumberValid.skip(1).subscribe(onNext: { value in
            if value == true {
                print("유효성 검사 성공: \(value)")
                self.isValid = true
                self.authMessageButton.status = .fill
            } else {
                self.isValid = false
                self.authMessageButton.status = .disable
            }
        }).disposed(by: disposeBag)

    }
    
    @objc func authMessageButtonClicked() {
        print(#function)
    }
    
    func trimNumber(_ number: String) {

        if number.count > 0 {
            //마지막으로 입력된거 문자니깐 textfield에서 지워줘야함
            var trimNum = number
            let lastInput = String(trimNum.removeLast())
            //print("number: \(number) trimNum: \(trimNum) last: \(lastInput)")

            if Int(lastInput) != nil {
                self.textfieldView.textfield.text = number
            } else {
                if lastInput == "-" {
                    print("얍")
                    self.textfieldView.textfield.text = number

                } else {
                    self.textfieldView.textfield.text = trimNum
                }
            }
         }
        
        
        //전화번호에 하이픈 넣기
        if number.count == 3 || number.count == 8 {
            self.textfieldView.textfield.text = number.appending("-")
        }
        
        //13자리 넘게 입력되지 않도록 함
        if number.count > 13 {
            let index = number.index(number.startIndex, offsetBy: 13)
            self.textfieldView.textfield.text = String(number[..<index])
        }
    }
}

extension LoginViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

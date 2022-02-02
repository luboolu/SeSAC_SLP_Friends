//
//  PhoneNumberAuthInputViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/21.
//

import UIKit

import Firebase
import FirebaseAuth
import SnapKit
import RxSwift
import RxCocoa
import Toast

class LoginConfirmViewController: UIViewController {
    
    var authCode: String?
    var timer: Timer?
    var timerNum: Int = 60
    
    let disposeBag = DisposeBag()
    let toastStyle = ToastStyle()
    let viewModel = UserViewModel()
    let mainView = LoginConfirmView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.makeToast("인증번호를 보냈습니다" ,duration: 2.0, position: .bottom, style: self.toastStyle)
        
        startTimer()
        setTextFieldRx()
        setButton()
        
        print("authVerificationID")
        print(UserDefaults.standard.string(forKey: UserdefaultKey.authVerificationID.string) ?? "")
        
        print("idtoken")
        print(UserDefaults.standard.string(forKey: UserdefaultKey.idToken.string) ?? "")
        
        print("fcmToken")
        print(UserDefaults.standard.string(forKey: UserdefaultKey.fcmToken.string) ?? "")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if timer != nil && timer!.isValid {
            timer!.invalidate()
        }
    }
    
    func startTimer() {
        //기존에 타이머 동작중이면 중지 처리
        if timer != nil && timer!.isValid {
            timer!.invalidate()
        }
     
        //타이머 사용값 초기화
        timerNum = 60
        //1초 간격 타이머 시작
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)

    }
    
    func setTextFieldRx() {
        
        //textfield의 입력값이 바뀔때 마다 감지 -> 유효성 검사
        mainView.authCodeTextField.textfield.rx.text
            .subscribe(onNext: { newValue in
                let result = self.trimNumber(newValue ?? "")
                self.mainView.authCodeTextField.textfield.text = result
                
                if result.count == 6 {
                    self.mainView.authButton.status = .fill
                } else {
                    self.mainView.authButton.status = .disable
                }
                
            }).disposed(by: disposeBag)
        
        //textfield가 활성화되는 시점을 감지
        mainView.authCodeTextField.textfield.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe(onNext: { _ in
                self.mainView.authCodeTextField.status = .active
                self.mainView.authCodeTextField.textfield.placeholder = "인증번호 입력"
            }).disposed(by: disposeBag)
        
        //textfield가 비활성화 되는 시점을 감지
        mainView.authCodeTextField.textfield.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: { _ in
                self.mainView.authCodeTextField.status = .inactive
                self.mainView.authCodeTextField.textfield.placeholder = "인증번호 입력"
            }).disposed(by: disposeBag)
        
    }
    
    func setButton() {
        
        mainView.authButton.rx.tap
            .bind { [self] in
                self.authButtonTapped()
            }.disposed(by: disposeBag)
        
        mainView.resendAuthButton.rx.tap
            .bind {
                self.resendButtonTapped()
            }.disposed(by: disposeBag)
        
    }
    
    func trimNumber(_ number: String) -> String {
        
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
    
    func authButtonTapped() {
        print("auth button clicked!")
        
        DispatchQueue.main.async {
            //1. 인증번호 6자리 입력 확인
            //인증번호 6자리가 모두 입력되었는지 확인
            if self.mainView.authCodeTextField.textfield.text?.count != 6 {
                self.view.makeToast("전화 번호 인증 실패" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                return
            }
            
            //2. 입력된 인증번호가 일치하는지 확인
            let inputCode = self.mainView.authCodeTextField.textfield.text ?? ""

            self.viewModel.authSignIn(inputCode: inputCode) { error in
                if error != nil {
                    self.view.makeToast("전화 번호 인증 실패" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    return
                }
            }
            
            //3. id token 요청
            self.viewModel.idTokenRequest { error in
                if error != nil {
                    self.view.makeToast("에러가 발생했습니다" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    return
                }
            }
            
            //4. 기존 회원인지 확인
            self.viewModel.getUser() { apiResult, getUserResult, data in
                print("statusCode: \(apiResult)")
                
                DispatchQueue.main.async {
                    //기존 유저인 경우
                    //5-1. 기존 회원이라면 main화면으로 전환
                    if getUserResult == .existingUser {
                        //루트 뷰 자체를 바꿔줌
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: MainViewController())
                        windowScene.windows.first?.makeKeyAndVisible()
                    } else if getUserResult == .newUser {
                        //미가입 유저인 경우
                        //닉네임 입력 화면으로 화면 전환!
                        //5-2. 미가입 회원이라면 닉네임 입력 화면으로 전환
                        let vc = NicknameViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }


    }
    
    func resendButtonTapped() {
        print("auth resend button clicked!")
        //firebase 인증 문자 재전송
        //firebase auth 시작
        let number = UserDefaults.standard.string(forKey: UserdefaultKey.phoneNumber.string) ?? ""
        
        self.viewModel.authRequest(phoneNumber: number) { error in
            if let error = error {
                if error.localizedDescription == "We have blocked all requests from this device due to unusual activity. Try again later." {
                    self.view.makeToast("과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요." ,duration: 2.0, position: .bottom, style: self.toastStyle)
                } else {
                    self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                }
            } else {
                //전화번호 인증 문자 전송 성공 -> 타이머 초기화
                //timer 초기화
                self.startTimer()
                self.view.makeToast("문자가 재전송되었습니다." ,duration: 2.0, position: .bottom, style: self.toastStyle)
            }
            
        }
    }
    
    //타이머 동작 func
    @objc func timerCallback() {
        
        let minute = Int(timerNum / 60)
        let seconds = Int(timerNum % 60)
        
        if seconds < 10 {
            self.mainView.authValidTime.text = "0\(minute):0\(seconds)"
        } else {
            self.mainView.authValidTime.text = "0\(minute):\(seconds)"
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

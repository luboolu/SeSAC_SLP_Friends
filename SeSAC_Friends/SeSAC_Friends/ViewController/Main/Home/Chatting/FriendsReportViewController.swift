//
//  FriendsReportViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/19.
//

import UIKit

import RxCocoa
import RxSwift
import RxKeyboard
import Toast

final class FriendsReportViewController: UIViewController {
    
    private let mainView = FriendsReportView()
    private let viewModel = UserViewModel()
    private let disposeBag = DisposeBag()
    private let toastStyle = ToastStyle()
    
    private var reportList = [0, 0, 0, 0, 0, 0]
    private var showPlaceHolder = true
    var friendUid : String?
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        setTextView()
        setKeyBoard()
    }
    
    private func setButton() {
        //dismissButton action
        mainView.dismissButton.addTarget(self, action: #selector(dismissButtonClicked), for: .touchUpInside)
        
        mainView.reportButton1.rx.tap
            .scan(mainView.reportButton1.status) { lastState, newState in
                if lastState == .inactive {
                    self.reportList[0] = 1
                    self.reportButtonStatus()
                    return .fill
                } else {
                    self.reportList[0] = 0
                    self.reportButtonStatus()
                    return .inactive
                }
            }.map { $0 }
            .bind(to: self.mainView.reportButton1.rx.status)
            .disposed(by: disposeBag)
        
        mainView.reportButton2.rx.tap
            .scan(mainView.reportButton2.status) { lastState, newState in
                if lastState == .inactive {
                    self.reportList[1] = 1
                    self.reportButtonStatus()
                    return .fill
                } else {
                    self.reportList[1] = 0
                    self.reportButtonStatus()
                    return .inactive
                }
            }.map { $0 }
            .bind(to: self.mainView.reportButton2.rx.status)
            .disposed(by: disposeBag)
        
        mainView.reportButton3.rx.tap
            .scan(mainView.reportButton3.status) { lastState, newState in
                if lastState == .inactive {
                    self.reportList[2] = 1
                    self.reportButtonStatus()
                    return .fill
                } else {
                    self.reportList[2] = 0
                    self.reportButtonStatus()
                    return .inactive
                }
            }.map { $0 }
            .bind(to: self.mainView.reportButton3.rx.status)
            .disposed(by: disposeBag)
        
        mainView.reportButton4.rx.tap
            .scan(mainView.reportButton4.status) { lastState, newState in
                if lastState == .inactive {
                    self.reportList[3] = 1
                    self.reportButtonStatus()
                    return .fill
                } else {
                    self.reportList[3] = 0
                    self.reportButtonStatus()
                    return .inactive
                }
            }.map { $0 }
            .bind(to: self.mainView.reportButton4.rx.status)
            .disposed(by: disposeBag)
        
        mainView.reportButton5.rx.tap
            .scan(mainView.reportButton5.status) { lastState, newState in
                if lastState == .inactive {
                    self.reportList[4] = 1
                    self.reportButtonStatus()
                    return .fill
                } else {
                    self.reportList[4] = 0
                    self.reportButtonStatus()
                    return .inactive
                }
            }.map { $0 }
            .bind(to: self.mainView.reportButton5.rx.status)
            .disposed(by: disposeBag)
        
        mainView.reportButton6.rx.tap
            .scan(mainView.reportButton6.status) { lastState, newState in
                if lastState == .inactive {
                    self.reportList[5] = 1
                    self.reportButtonStatus()
                    return .fill
                } else {
                    self.reportList[5] = 0
                    self.reportButtonStatus()
                    return .inactive
                }
            }.map { $0 }
            .bind(to: self.mainView.reportButton6.rx.status)
            .disposed(by: disposeBag)
        
        mainView.reportButton.rx.tap
            .bind {
                if self.reportList.contains(1) == false {
                    DispatchQueue.main.async {
                        self.view.makeToast("하나 이상의 신고 항목을 선택해주세요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    }
                } else {
                    self.reportFriend()
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setTextView() {
        mainView.reportTextView.rx.didBeginEditing
            .subscribe( onNext: { newValue in
                print("편집 시작")
                if self.showPlaceHolder {
                    self.mainView.reportTextView.text = ""
                    self.mainView.reportTextView.textColor = UIColor().black
                    self.showPlaceHolder = false
                }
            }).disposed(by: disposeBag)
    }
    
    private func setKeyBoard() {
        initializeKeyboard()
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { keyboardVisibleHeight in
                UIView.animate(withDuration: 0.5) {
                    self.mainView.reportButton.snp.updateConstraints { make in
                        if keyboardVisibleHeight == 0 {
                            make.bottom.equalToSuperview().offset(-16)
                        } else {
                            make.bottom.equalToSuperview().inset( keyboardVisibleHeight - 30)
                        }
                    }
                }
                self.view.layoutIfNeeded()
            }).disposed(by: disposeBag)
    }
    
    private func reportFriend() {
        print(#function)
        guard let otherUid = self.friendUid else { return }
        let comment = mainView.reportTextView.text ?? ""
        
        viewModel.userReport(otherUid: otherUid, report: self.reportList, comment: comment) { apiResult, userReportResult in
            if let userReportResult = userReportResult {
                switch userReportResult {
                case .succeed:
                    print("신고하기 성공")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                case .tokenError:
                    self.reportFriend()
                case .notUser:
                    DispatchQueue.main.async {
                        //온보딩 화면으로 이동
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: OnBoardingViewController())
                        windowScene.windows.first?.makeKeyAndVisible()
                    }
                case .serverError:
                    DispatchQueue.main.async {
                        self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    }
                case .clientError:
                    DispatchQueue.main.async {
                        self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    }
                }
            }
        }
    }
    
    @objc private func dismissButtonClicked() {
        print(#function)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func reportButtonStatus() {
        if self.reportList.contains(1) {
            self.mainView.reportButton.status = .fill
        } else {
            self.mainView.reportButton.status = .disable
        }
    }
}

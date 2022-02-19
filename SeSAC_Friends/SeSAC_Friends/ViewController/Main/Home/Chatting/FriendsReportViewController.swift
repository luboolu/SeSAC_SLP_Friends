//
//  FriendsReportViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/19.
//

import UIKit

import RxCocoa
import RxSwift
import Toast

final class FriendsReportViewController: UIViewController {
    
    private let mainView = FriendsReportView()
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
    }
    
    private func setButton() {
        //dismissButton action
        mainView.dismissButton.addTarget(self, action: #selector(dismissButtonClicked), for: .touchUpInside)
        
        mainView.reportButton1.rx.tap
            .scan(mainView.reportButton1.status) { lastState, newState in
                if lastState == .inactive {
                    self.reportList[0] = 1
                    return .fill
                } else {
                    self.reportList[0] = 0
                    return .inactive
                }
            }.map { $0 }
            .bind(to: self.mainView.reportButton1.rx.status)
            .disposed(by: disposeBag)
        
        mainView.reportButton2.rx.tap
            .scan(mainView.reportButton2.status) { lastState, newState in
                if lastState == .inactive {
                    self.reportList[1] = 1
                    return .fill
                } else {
                    self.reportList[1] = 0
                    return .inactive
                }
            }.map { $0 }
            .bind(to: self.mainView.reportButton2.rx.status)
            .disposed(by: disposeBag)
        
        mainView.reportButton3.rx.tap
            .scan(mainView.reportButton3.status) { lastState, newState in
                if lastState == .inactive {
                    self.reportList[2] = 1
                    return .fill
                } else {
                    self.reportList[2] = 0
                    return .inactive
                }
            }.map { $0 }
            .bind(to: self.mainView.reportButton3.rx.status)
            .disposed(by: disposeBag)
        
        mainView.reportButton4.rx.tap
            .scan(mainView.reportButton4.status) { lastState, newState in
                if lastState == .inactive {
                    self.reportList[3] = 1
                    return .fill
                } else {
                    self.reportList[3] = 0
                    return .inactive
                }
            }.map { $0 }
            .bind(to: self.mainView.reportButton4.rx.status)
            .disposed(by: disposeBag)
        
        mainView.reportButton5.rx.tap
            .scan(mainView.reportButton5.status) { lastState, newState in
                if lastState == .inactive {
                    self.reportList[4] = 1
                    return .fill
                } else {
                    self.reportList[4] = 0
                    return .inactive
                }
            }.map { $0 }
            .bind(to: self.mainView.reportButton5.rx.status)
            .disposed(by: disposeBag)
        
        mainView.reportButton6.rx.tap
            .scan(mainView.reportButton6.status) { lastState, newState in
                if lastState == .inactive {
                    self.reportList[5] = 1
                    return .fill
                } else {
                    self.reportList[5] = 0
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
        
        mainView.reportTextView.rx.text.changed
            .subscribe(onNext: { newValue in
                print(newValue)
                if newValue?.count ?? 0 > 0 {
                    self.mainView.reportButton.status = .fill
                } else {
                    self.mainView.reportButton.status = .disable
                }
            }).disposed(by: disposeBag)
        

    }
    
    private func reportFriend() {
        print(#function)
    }
    
    @objc private func dismissButtonClicked() {
        print(#function)
        self.dismiss(animated: true, completion: nil)
    }
}

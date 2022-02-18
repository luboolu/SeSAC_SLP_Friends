//
//  FriendsReviewViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/17.
//

import UIKit

import RxCocoa
import RxSwift
import Toast

final class FriendsReviewViewController: UIViewController {
    
    private let mainView = FriendsReviewView()
    private let viewModel = QueueViewModel()
    private let disposeBag = DisposeBag()
    private let toastStyle = ToastStyle()
    
    private var showPlaceHolder = true
    private var reputation = [0, 0, 0, 0, 0, 0, 0, 0]
    var friendUid : String?
    var friendNick: String?
    
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        setButton()
        setTextView()
    }
    
    private func setTitle() {
        mainView.viewSubTitleLabel.text = "\(friendNick)님과의 취미 활동은 어떠셨나요?"
    }
    
    private func setButton() {
        //dismissButton action
        mainView.dismissButton.addTarget(self, action: #selector(dismissButtonClicked), for: .touchUpInside)
        //Reputation Button
        mainView.reputationButton1.rx.tap
            .scan(mainView.reputationButton1.status) { lastState, newState in
                if lastState == .inactive {
                    self.reputation[0] = 1
                    return .fill
                } else {
                    self.reputation[0] = 0
                    return .disable
                }
            }
            .map { $0 }
            .bind(to: self.mainView.reputationButton1.rx.status)
            .disposed(by: disposeBag)
        
        mainView.reputationButton2.rx.tap
            .scan(mainView.reputationButton2.status) { lastState, newState in
                if lastState == .inactive {
                    self.reputation[1] = 1
                    return .fill
                } else {
                    self.reputation[1] = 0
                    return .disable
                }
            }
            .map { $0 }
            .bind(to: self.mainView.reputationButton2.rx.status)
            .disposed(by: disposeBag)
        
        mainView.reputationButton3.rx.tap
            .scan(mainView.reputationButton3.status) { lastState, newState in
                if lastState == .inactive {
                    self.reputation[2] = 1
                    return .fill
                } else {
                    self.reputation[2] = 0
                    return .disable
                }
            }
            .map { $0 }
            .bind(to: self.mainView.reputationButton3.rx.status)
            .disposed(by: disposeBag)
        
        mainView.reputationButton4.rx.tap
            .scan(mainView.reputationButton4.status) { lastState, newState in
                if lastState == .inactive {
                    self.reputation[3] = 1
                    return .fill
                } else {
                    self.reputation[3] = 0
                    return .disable
                }
            }
            .map { $0 }
            .bind(to: self.mainView.reputationButton4.rx.status)
            .disposed(by: disposeBag)
        
        mainView.reputationButton5.rx.tap
            .scan(mainView.reputationButton5.status) { lastState, newState in
                if lastState == .inactive {
                    self.reputation[4] = 1
                    return .fill
                } else {
                    self.reputation[4] = 0
                    return .disable
                }
            }
            .map { $0 }
            .bind(to: self.mainView.reputationButton5.rx.status)
            .disposed(by: disposeBag)
        
        mainView.reputationButton6.rx.tap
            .scan(mainView.reputationButton6.status) { lastState, newState in
                if lastState == .inactive {
                    self.reputation[5] = 1
                    return .fill
                } else {
                    self.reputation[5] = 0
                    return .disable
                }
            }
            .map { $0 }
            .bind(to: self.mainView.reputationButton6.rx.status)
            .disposed(by: disposeBag)
        
        //RegisterButton
        mainView.registerButton.rx.tap
            .bind {
                if self.mainView.reviewTextView.text.count == 0 || self.showPlaceHolder == true {
                    DispatchQueue.main.async {
                        self.view.makeToast("리뷰를 작성해주세요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    }
                } else if self.reputation.contains(1) == false {
                    DispatchQueue.main.async {
                        self.view.makeToast("하나 이상의 타이틀을 선택해주세요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    }
                } else {
                    print("성공")
                    self.sendReview()
                }
            }.disposed(by: disposeBag)
    }
    
    private func setTextView() {
        mainView.reviewTextView.rx.didBeginEditing
            .subscribe( onNext: { newValue in
                print("편집 시작")
                if self.showPlaceHolder {
                    self.mainView.reviewTextView.text = ""
                    self.mainView.reviewTextView.textColor = UIColor().black
                    self.showPlaceHolder = false
                }
            }).disposed(by: disposeBag)
        
        mainView.reviewTextView.rx.text.changed
            .subscribe(onNext: { newValue in
                print(newValue)
                if newValue?.count ?? 0 > 0 {
                    self.mainView.registerButton.status = .fill
                } else {
                    self.mainView.registerButton.status = .disable
                }
            }).disposed(by: disposeBag)
    }
    
    @objc private func dismissButtonClicked() {
        print(#function)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func sendReview() {
        guard let friendUid = friendUid, let myUid = UserDefaults.standard.string(forKey: UserdefaultKey.uid.rawValue) else {
            return
        }
        
        print(friendUid)
        print(myUid)
        
    }
    
    
}

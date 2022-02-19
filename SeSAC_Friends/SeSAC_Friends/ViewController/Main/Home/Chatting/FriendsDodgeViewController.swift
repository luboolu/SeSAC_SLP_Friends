//
//  FriendsDodgeViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/20.
//

import UIKit

import RxCocoa
import RxSwift
import Toast

final class FriendsDodgeViewController: UIViewController {
    
    private let mainView = FriendsDodgeView()
    private let viewModel = QueueViewModel()
    private let toastStyle = ToastStyle()
    
    var friendUid: String?
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButton()
    }
    
    private func setButton() {
        mainView.cancleButton.addTarget(self, action: #selector(dismissButtonClicked), for: .touchUpInside)
        mainView.confirmButton.addTarget(self, action: #selector(confirmButtonClicked), for: .touchUpInside)
    }
    
    @objc private func dismissButtonClicked() {
        print(#function)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func confirmButtonClicked() {
        print(#function)
        guard let other = self.friendUid else { return }
        
        viewModel.queueDodge(otherUID: other) { apiResult, queueDodge in
            if let queueDodge = queueDodge {
                print(queueDodge)
                switch queueDodge {
                case .succeed:
                    DispatchQueue.main.async {
                        //매칭상태 일반 상태로 변경
                        UserDefaults.standard.set(matchingState.noState.rawValue, forKey: UserdefaultKey.matchingState.rawValue)
                        //홈 화면으로 이동
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: MainViewController())
                        windowScene.windows.first?.makeKeyAndVisible()
                    }
                case .wrongUID:
                    DispatchQueue.main.async {
                        self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    }
                case .tokenError:
                    self.confirmButtonClicked()
                    return
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
}

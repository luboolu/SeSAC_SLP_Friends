//
//  AcceptPopUpViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/21.
//

import UIKit

import RxCocoa
import RxSwift
import Toast

final class AcceptPopUpViewController: UIViewController {
    
    private let mainView = AcceptPopUpView()
    private let viewModel = QueueViewModel()
    private let toastStyle = ToastStyle()
    
    var friendUid: String?
    lazy var mainTitle = ""
    lazy var subTitle = ""
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButton()
        setTitle()
    }
    
    private func setButton() {
        mainView.cancleButton.addTarget(self, action: #selector(dismissButtonClicked), for: .touchUpInside)
        mainView.confirmButton.addTarget(self, action: #selector(confirmButtonClicked), for: .touchUpInside)
    }
    
    private func setTitle() {
        mainView.viewTitleLabel.text = "\(mainTitle)"
        mainView.viewSubTitleLabel.text = "\(subTitle)"
    }
    
    @objc private func dismissButtonClicked() {
        print(#function)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func confirmButtonClicked() {
        print(#function)
        self.dismiss(animated: true) {
            if let friendUid = self.friendUid {
                let vc = RecivedViewController()
                vc.acceptBeFriend(uid: friendUid)
            }
        }
    }
}

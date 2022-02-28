//
//  WithdrawPopUpViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/28.
//

import UIKit

import RxCocoa
import RxSwift

final class WithdrawPopUpViewController: UIViewController {
    
    private let mainView = WithdrawPopUpView()
    private let viewModel = UserViewModel()
    
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
            let vc = MyInfoViewController()
            vc.userWithdrawRequest()
        }
    }
}

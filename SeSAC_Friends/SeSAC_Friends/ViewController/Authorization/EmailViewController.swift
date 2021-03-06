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

final class EmailViewController: UIViewController {
    
    private let toastStyle = ToastStyle()
    private let disposeBag = DisposeBag()
    private let mainView = EmailView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextField()
        setButton()
        initializeKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = UIColor().black
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func setTextField() {
        mainView.emailTextField.textfield.rx.text
            .subscribe(onNext: { newValue in
                
                if newValue?.count ?? 0 > 0 {
                    self.mainView.nextButton.status = .fill
                } else {
                    self.mainView.nextButton.status = .disable
                }
                
            }).disposed(by: disposeBag)
    }
    
    private func setButton() {
        mainView.nextButton.rx.tap
            .bind {
                self.nextButtonTapped()
            }
    }
    
    private func nextButtonTapped() {
        let input = mainView.emailTextField.textfield.text ?? ""
        
        if isValidEmail(email: input) {
            UserDefaults.standard.set(input, forKey: UserdefaultKey.email.rawValue)
            
            let vc = GenderViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.view.makeToast("이메일 형식이 올바르지 않습니다" ,duration: 2.0, position: .bottom, style: self.toastStyle)
        }
        
    }
    
    private func isValidEmail(email: String?) -> Bool {
        guard email != nil else { return false}
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let pred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return pred.evaluate(with: email)
    }
    
    
}

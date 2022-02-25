//
//  ViewController+Extension.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/25.
//

import UIKit

import RxCocoa
import RxSwift
import RxKeyboard
import SnapKit

extension UIViewController {

    func initializeKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

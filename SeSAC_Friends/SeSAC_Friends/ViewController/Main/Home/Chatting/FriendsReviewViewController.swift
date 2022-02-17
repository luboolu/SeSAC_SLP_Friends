//
//  FriendsReviewViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/17.
//

import UIKit

import RxCocoa
import RxSwift

final class FriendsReviewViewController: UIViewController {
    
    private let mainView = FriendsReviewView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.dismissButton.addTarget(self, action: #selector(dismissButtonClicked), for: .touchUpInside)
    }
    
    @objc private func dismissButtonClicked() {
        print(#function)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

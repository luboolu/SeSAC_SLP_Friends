//
//  ChattingMenuViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/15.
//

import UIKit

import RxCocoa
import RxSwift

final class ChattingMenuViewController: UIViewController {
    let mainView = ChattingMenuView()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}

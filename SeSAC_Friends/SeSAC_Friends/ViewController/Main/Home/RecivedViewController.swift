//
//  RecivedViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/08.
//
import UIKit

import RxCocoa
import RxSwift

final class RecivedViewController: UIViewController {
    
    private let mainView = RecivedView()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//
//  ChattingViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/15.
//

import UIKit

import RxCocoa
import RxSwift

final class ChattingViewController: UIViewController {
    
    private let mainView = ChattingView()
    private let disposeBag = DisposeBag()
    
    private var menuButtonIsClicked = true
    
    var friendNick: String?
    var friendUid: String?
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setTextView()
        setChatMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor().black
        self.navigationItem.title = "상대방 닉네임"
         
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(menuButtonClicked))
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = UIColor().black
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func setTableView() {
        mainView.chattingTableView.delegate = self
        mainView.chattingTableView.dataSource = self
        
        mainView.chattingTableView.register(MyChattingTableViewCell.self, forCellReuseIdentifier: TableViewCell.MyChattingTableViewCell.id)
        mainView.chattingTableView.register(FriendsChattingTableViewCell.self, forCellReuseIdentifier: TableViewCell.FriendsChattingTableViewCell.id)
    }
    
    private func setTextView() {
        mainView.messageTextView.rx.text.changed
            .subscribe(onNext: { newValue in
                
                let num = newValue?.count ?? 0
                
                if num > 0 {
                    self.mainView.messageButton.setImage(UIImage(named: "message_send_color"), for: .normal)
                    self.mainView.messageButton.isEnabled = true
                } else {
                    self.mainView.messageButton.setImage(UIImage(named: "message_send"), for: .normal)
                    self.mainView.messageButton.isEnabled = false
                }
                
                print(newValue?.count ?? 0)
                if newValue?.count ?? 0 > 90 {
                    self.mainView.messageTextView.isScrollEnabled = true
                } else {
                    self.mainView.messageTextView.isScrollEnabled = false
                }
            }).disposed(by: disposeBag)
        
        mainView.messageTextView.rx.didBeginEditing
            .subscribe( onNext: { newValue in
                print("편집 시작")
                self.mainView.messageTextView.text = ""
                self.mainView.messageTextView.textColor = UIColor().black
            }).disposed(by: disposeBag)
    }
    
    private func setChatMenu() {
        mainView.reportButton.rx.tap
            .bind {
                print("reportButton tapped")
            }.disposed(by: disposeBag)
        
        mainView.cancelButton.rx.tap
            .bind {
                print("cancelButton tapped")
            }.disposed(by: disposeBag)
        
        mainView.reviewButton.rx.tap
            .bind {
                DispatchQueue.main.async {
                    print("reviewButton tapped")
                    let popUp = FriendsReviewViewController()
                    popUp.modalPresentationStyle = .overCurrentContext
                    popUp.modalTransitionStyle = .crossDissolve
                    self.present(popUp, animated: true, completion: nil)
                }
            }.disposed(by: disposeBag)
    }
    
    @objc private func menuButtonClicked() {
        print(#function)
        self.menuButtonIsClicked = !self.menuButtonIsClicked
        mainView.reportButton.isHidden = self.menuButtonIsClicked
        mainView.cancelButton.isHidden = self.menuButtonIsClicked
        mainView.reviewButton.isHidden = self.menuButtonIsClicked
//        let vc = ChattingMenuViewController()
//
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//
//        self.present(vc, animated: true, completion: nil)
    }
}

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.MyChattingTableViewCell.id) as? MyChattingTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.timeLabel.text = "12:09"
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.FriendsChattingTableViewCell.id) as? FriendsChattingTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.timeLabel.text = "12:09"
            
            return cell
        }

    }
    
    
}
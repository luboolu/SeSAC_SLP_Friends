//
//  ChattingViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/15.
//

import UIKit

import RxCocoa
import RxSwift
import Toast

final class ChattingViewController: UIViewController {
    
    private let mainView = ChattingView()
    private let viewModel = QueueViewModel()
    private let disposeBag = DisposeBag()
    private let toastStyle = ToastStyle()
    
    private var menuButtonIsClicked = true
    private var matchingInfo: MyQueueState?
    
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
        
        updateMyState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor().black
        self.navigationItem.title = "\(friendNick ?? "")"
         
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
                DispatchQueue.main.async {
                    print("reportButton tapped")
                    let popUp = FriendsReportViewController()
                    popUp.friendUid = self.matchingInfo?.matchedUid
                    popUp.modalPresentationStyle = .overCurrentContext
                    popUp.modalTransitionStyle = .crossDissolve
                    self.present(popUp, animated: true, completion: nil)
                }
            }.disposed(by: disposeBag)
        
        mainView.cancelButton.rx.tap
            .bind {
                DispatchQueue.main.async {
                    print("cancelButton tapped")
                    let popUp = FriendsDodgeViewController()
                    popUp.friendUid = self.matchingInfo?.matchedUid
                    popUp.modalPresentationStyle = .overCurrentContext
                    popUp.modalTransitionStyle = .crossDissolve
                    self.present(popUp, animated: true, completion: nil)
                }
            }.disposed(by: disposeBag)
        
        mainView.reviewButton.rx.tap
            .bind {
                DispatchQueue.main.async {
                    print("reviewButton tapped")
                    let popUp = FriendsReviewViewController()
                    popUp.friendUid = self.matchingInfo?.matchedUid
                    popUp.friendNick = self.matchingInfo?.matchedNick
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
    }
    
    private func updateMyState() {
        print(#function)
        
        viewModel.queueMyState { apiResult, queueState, myQueueState in
            if let queueState = queueState {
                switch queueState {
                case .succeed:
                    DispatchQueue.main.async {
                        if let myQueueState = myQueueState {
                            print(myQueueState)
                            self.matchingInfo = myQueueState
                            self.friendUid = myQueueState.matchedUid
                            self.friendNick = myQueueState.matchedNick
                            self.navigationItem.title = "\(self.friendNick ?? "")"
                            self.reloadInputViews()
                        }
                    }
                case .stopped:
                    DispatchQueue.main.async {
                        self.view.makeToast("오랜 시간 동안 매칭되지 않아 새싹 친구 찾기를 그만둡니다." ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    }
                case .tokenError:
                    self.updateMyState()
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

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.MyChattingTableViewCell.id) as? MyChattingTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.timeLabel.text = "12:09"
            cell.chatTextView.text = "내가 보낸 채팅"
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.FriendsChattingTableViewCell.id) as? FriendsChattingTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.chatTextView.text = "친구가 보낸 채팅"
            cell.timeLabel.text = "12:09"
            
            return cell
        }

    }

    
    
}

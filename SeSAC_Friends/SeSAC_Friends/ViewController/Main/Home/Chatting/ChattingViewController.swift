//
//  ChattingViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/15.
//

import UIKit

import Alamofire
import RxCocoa
import RxSwift
import RxKeyboard
import RealmSwift
import Toast
import SocketIO

final class ChattingViewController: UIViewController {
    
    private let mainView = ChattingView()
    private let viewModel = QueueViewModel()
    private let chatViewModel = ChattingViewModel()
    private let disposeBag = DisposeBag()
    private let toastStyle = ToastStyle()
    private let localRealm = try! Realm()
    private let myUid = UserDefaults.standard.string(forKey: UserdefaultKey.uid.rawValue) ?? ""
    
    private var menuButtonIsClicked = true
    private var matchingInfo: MyQueueState?
    private var chattingData: GetChatData?
    private var tasks: Results<UserChatting>! {
        didSet {
            self.mainView.chattingTableView.reloadData()
            //print(tasks)
        }
    }
    
    var friendNick: String?
    var friendUid: String? {
        didSet {
            self.tasks = localRealm.objects(UserChatting.self).filter("from == '\(friendUid ?? "")' or to == '\(friendUid ?? "")'").sorted(byKeyPath: "createdAt", ascending: true)
            self.getChat()
        }
    }

    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Realm 파일 위치
        print("Realm is loacaed at: ", localRealm.configuration.fileURL!)
        initializeKeyboard()
        setTableView()
        setTextView()
        setChatMenu()
        
        mainView.messageButton.addTarget(self, action: #selector(messageButtonClicked), for: .touchUpInside)
        
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { keyboardVisibleHeight in
                UIView.animate(withDuration: 0.5) {
                    self.mainView.messageView.snp.updateConstraints { make in
                        if keyboardVisibleHeight == 0 {
                            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
                        } else {
                            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset( keyboardVisibleHeight - 30)
                            if self.tasks.count > 0 {
                                self.mainView.chattingTableView.scrollToRow(at: [0, self.tasks.count - 1], at: .bottom, animated: true)
                            }
                        }
                    }
                }
                self.view.layoutIfNeeded()
            }).disposed(by: disposeBag)
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
        
        DispatchQueue.main.async {
            self.updateMyState()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        socketDisConnect()
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
    
    @objc private func messageButtonClicked() {
        let text = mainView.messageTextView.text ?? ""
        print(text)
        
        guard let friendUid = friendUid else {
            return
        }

        chatViewModel.postChat(uid: friendUid, message: text) { apiResult, postChat, postChatResult in
            if let postChat = postChat {
                switch postChat {
                case .succeed:
                    if let postChatResult = postChatResult {

                        let data = UserChatting(to: postChatResult.to, from: postChatResult.from, chat: postChatResult.chat, createdAt: postChatResult.createdAt)

                        DispatchQueue.main.async {
                            //Realm 데이터 추가
                            try! self.localRealm.write {
                                self.localRealm.add(data)
                            }
                            self.mainView.chattingTableView.reloadData()
                            if self.tasks.count > 0 {
                                self.mainView.chattingTableView.scrollToRow(at: [0, self.tasks.count - 1], at: .bottom, animated: true)
                            }
                            
                        }
                        
                    }
                case .notMatched:
                    DispatchQueue.main.async {
                        self.view.makeToast("매칭 상태가 아니라 채팅을 전송할 수 없습니다" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    }
                case .tokenError:
                    self.messageButtonClicked()
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
        
        //채팅 보내고 난 후에 textView 초기화
        mainView.messageTextView.text = ""
        
        //mainView.chattingTableView.scrollToRow(at: [0, 9], at: .bottom, animated: true)
    }
    
    private func updateMyState() {
        print(#function)
        
        viewModel.queueMyState { apiResult, queueState, myQueueState in
            if let queueState = queueState {
                switch queueState {
                case .succeed:
                    DispatchQueue.main.async {
                        if let myQueueState = myQueueState {
                            //print(myQueueState)
                            self.matchingInfo = myQueueState
                            self.friendUid = myQueueState.matchedUid
                            self.friendNick = myQueueState.matchedNick
                            self.isMatched(info: myQueueState)
                            //self.getChat()
                            print("친구: ", self.friendUid)
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
    
    private func isMatched(info: MyQueueState) -> Bool {
        print(info)
        if info.matched == 0 {
            DispatchQueue.main.async {
                self.view.makeToast("약속이 종료되어 메세지를 보낼 수 없습니다" ,duration: 2.0, position: .bottom, style: self.toastStyle)
            }
            return false
        } else if info.dodged == 1 {
            DispatchQueue.main.async {
                self.view.makeToast("상대방이 약속을 취소했습니다" ,duration: 2.0, position: .bottom, style: self.toastStyle)
            }
            return false
        } else if info.reviewed == 1 {
            DispatchQueue.main.async {
                self.view.makeToast("약속이 종료되어 메세지를 보낼 수 없습니다. 리뷰를 남겨주세요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
            }
            return false
        } else {
            return true
        }
    }
    
    private func getChat() {
        print(#function)
        guard let friendUid = self.friendUid else {
            return
        }
        
        if let lastDate = self.tasks.last?.createdAt {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//
//            let createdDate = dateFormatter.string(from: lastDate)
//
//            print(createdDate)

            chatViewModel.getChattingData(uid: friendUid, lastChatDate: lastDate) { apiResult, getChat, getChatData in
                print(getChat)
                if let getChat = getChat {
                    switch getChat {
                    case .succeed:
                        DispatchQueue.main.async {
                            if let getChatData = getChatData {
                                //print(getChatData)
                                
                                for chat in getChatData.payload {

                                    let data = UserChatting(to: chat.to, from: chat.from, chat: chat.chat, createdAt: chat.createdAt)
                                    print(data)
                                    //Realm 데이터 추가
                                    try! self.localRealm.write {
                                        self.localRealm.add(data)
                                    }
                                }
                                self.socketConnect()
                                self.mainView.chattingTableView.reloadData()
                                
                                if self.tasks.count > 0 {
                                    //self.mainView.chattingTableView.scrollToRow(at: [0, self.tasks.count - 1], at: .bottom, animated: true)
                                }
                            }
                        }
                    case .tokenError:
                        self.getChat()
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
        } else {

            chatViewModel.getChattingData(uid: friendUid, lastChatDate: "2000-01-01T00:00:00.000Z") { apiResult, getChat, getChatData in
                
                if let getChat = getChat {
                    switch getChat {
                    case .succeed:
                        DispatchQueue.main.async {
                            if let getChatData = getChatData {
                                for chat in getChatData.payload {
                                    let data = UserChatting(to: chat.to, from: chat.from, chat: chat.chat, createdAt: chat.createdAt)
                                    print(data)
                                    //Realm 데이터 추가
                                    try! self.localRealm.write {
                                        self.localRealm.add(data)
                                    }
                                }
                                
                                self.mainView.chattingTableView.reloadData()
                            }
                        }
                    case .tokenError:
                        self.getChat()
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

    
    @objc func getMessage(notification: NSNotification) {
        print(#function)
        //print(notification)
        
        let id = notification.userInfo?["_id"] as! String
        let chat = notification.userInfo?["chat"] as! String
        let createdAt = notification.userInfo?["createdAt"] as! String
        let from = notification.userInfo?["from"] as! String
        let to = notification.userInfo?["to"] as! String
        
        let data = UserChatting(to: to, from: from, chat: chat, createdAt: createdAt)
        print(data)
        DispatchQueue.main.async {
                //Realm 데이터 추가
            try! self.localRealm.write {
                self.localRealm.add(data)
            }
            self.mainView.chattingTableView.reloadData()
            if self.tasks.count > 0 {
                self.mainView.chattingTableView.scrollToRow(at: [0, self.tasks.count - 1], at: .bottom, animated: true)
            }
        }

    }
    
    private func socketConnect() {
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
        SocketIOManager.shared.establishConnection()
    }
    
    private func socketDisConnect() {
        //화면이 사라지면, 소켓 연결을 끊는다
        SocketIOManager.shared.closeConnection()
        //노티피게이션 remove -> 해주지 않으면 notification이 중복으로 오게 된다
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("getMessage"), object: nil)
    }
}

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.chattingData?.payload.count ?? 0
        return self.tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let row = self.tasks?[indexPath.row] else { return UITableViewCell() }
        let from = row.from

        if from == self.friendUid {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.FriendsChattingTableViewCell.id) as? FriendsChattingTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.chatTextView.text = "\(row.chat)"
            
            if let isoTime = DateFormatter.isoFormat.date(from: row.createdAt) {
                let chatTime = DateFormatter.chattingTime.string(from: isoTime)
                cell.timeLabel.text = "\(chatTime)"
            }
            
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.MyChattingTableViewCell.id) as? MyChattingTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.chatTextView.text = "\(row.chat)"
            
            if let isoTime = DateFormatter.isoFormat.date(from: row.createdAt) {
                let chatTime = DateFormatter.chattingTime.string(from: isoTime)
                cell.timeLabel.text = "\(chatTime)"
            }
            
            return cell
        }

    }


    
    
}

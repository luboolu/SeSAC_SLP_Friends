//
//  RecivedViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/08.
//
import UIKit

import RxCocoa
import RxSwift
import Toast

final class RecivedViewController: UIViewController {
    
    private let mainView = RecivedView()
    private let viewModel = QueueViewModel()
    private let disposeBag = DisposeBag()
    private let toastStyle = ToastStyle()
    
    private var moreButtonTapped = [true, true, true]
    private var friendsNum = 3
    
    private var wantedHobby = [["코딩1", "iOS1","보드게임1"],["코딩2", "iOS2","보드게임2"],["코딩3", "iOS3","보드게임3"]]
    
    var recivedData: QueueOnData?
    var region: Int?
    var location: [Double]?
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.friendsTableView.delegate = self
        mainView.friendsTableView.dataSource = self
        
        //custom tableview cell register
        mainView.friendsTableView.register(CardTableViewCell.self, forCellReuseIdentifier: TableViewCell.CardTableViewCell.id)
        mainView.friendsTableView.register(CharactorTableViewCell.self, forCellReuseIdentifier: TableViewCell.CharactorTableViewCell.id)
        mainView.friendsTableView.register(EmptySeSacTableViewCell.self, forCellReuseIdentifier: TableViewCell.EmptySeSacTableViewCell.id)
        
        if let recivedData = recivedData {
            self.moreButtonTapped.removeAll()
            
            for _ in 0...recivedData.fromQueueDB.count {
                self.moreButtonTapped.append(true)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
            self.findFriends()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        print(recivedData)
        
        findFriends()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func findFriends() {
        guard let region = region, let location = location else {
            return
        }

        viewModel.queueOn(region: region, lat: location[0], long: location[1]) { apiResult, queueOn, queueOnData in
            print("새싹친구찾기 결과")
            print(queueOn)
            if let queueOn = queueOn {
                switch queueOn {
                case .succeed:
                    if let queueOnData = queueOnData {
                        DispatchQueue.main.async {
                            //기존의 moreButtonTapped의 값을 그대로 유지해야함
                            print("friends 데이터 갱신~~")
                            self.moreButtonTapped.removeAll()

                            for _ in 0...queueOnData.fromQueueDB.count {
                                self.moreButtonTapped.append(true)
                            }
                            self.recivedData = queueOnData
                            self.mainView.friendsTableView.reloadData()
                        }
                    }
                case .tokenError:
                    self.findFriends()
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
    
    func acceptBeFriend(uid: String) {
        viewModel.queueAccept(otherUID: uid) { apiResult, queueHobbyAccept in
            if let queueHobbyAccept = queueHobbyAccept {
                switch queueHobbyAccept {
                case .succeed:
                    DispatchQueue.main.async {
                        //매칭 상태 변경
                        UserDefaults.standard.set(matchingState.matched.rawValue, forKey: UserdefaultKey.matchingState.rawValue)
                        //팝업 화면 dismiss
                        //채팅 화면으로 전환
                        let vc = ChattingViewController()
                        vc.friendUid = uid
                        //vc.friendNick = recivedData.fromQueueDBRequested[section].nick
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                case .otherMatched:
                    DispatchQueue.main.async {
                        self.view.makeToast("상대방이 이미 다른 사람과 취미를 함께하는 중입니다" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    }
                case .stopped:
                    DispatchQueue.main.async {
                        self.view.makeToast("상대방이 취미 함께하기를 그만두었습니다" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    }
                case .otherAccepted:
                    DispatchQueue.main.async {
                        self.view.makeToast("앗! 누군가가 나의 취미 함께하기를 수락하였어요!" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                        self.updateMyState()
                    }
                case .tokenError:
                    self.acceptBeFriend(uid: uid)
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
    
    private func moreButtonClicked(section: Int, row: Int) {
        self.moreButtonTapped[section] = !self.moreButtonTapped[section]
        self.mainView.friendsTableView.reloadRows(at: [[section, row]], with: .fade)
        
        //카드 뷰가 접히면, 데이터 갱신
        if self.moreButtonTapped[section] {
            self.findFriends()
        }
        
        self.viewDidLayoutSubviews()
    }
    
    private func matchingButtonClicked(section: Int, row: Int) {
        print(#function)
        
        let popUp = AcceptPopUpViewController()
        popUp.mainTitle = "취미 같이 하기를 수락할까요?"
        popUp.subTitle = "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요"
        popUp.friendUid = recivedData?.fromQueueDBRequested[section].uid
        popUp.modalPresentationStyle = .overCurrentContext
        popUp.modalTransitionStyle = .crossDissolve
        self.present(popUp, animated: true, completion: nil)
    }
    
    private func updateMyState() {
        print(#function)
        
        viewModel.queueMyState { apiResult, queueState, myQueueState in
            if let queueState = queueState {
                switch queueState {
                case .succeed:
                    if let myQueueState = myQueueState {
                        print(myQueueState)
                        DispatchQueue.main.async {
                            if myQueueState.matched == 1 {
                                //매칭된 상태이므로 토스트 메세지를 띄우고, 채팅방으로 이동
                                self.view.makeToast("000님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다." ,duration: 2.0, position: .bottom, style: self.toastStyle)
                                
                                let vc = ChattingViewController()
                                vc.friendUid = myQueueState.matchedUid
                                vc.friendNick = myQueueState.matchedNick
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
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

extension RecivedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let dataNum = self.recivedData?.fromQueueDBRequested.count ?? 0
        
        if dataNum == 0 {
            print("section 1개")
            return 1
        } else {
            return dataNum
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataNum = self.recivedData?.fromQueueDBRequested.count ?? 0
        
        if dataNum == 0 {
            print("row 1개")
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dataNum = self.recivedData?.fromQueueDBRequested.count ?? 0
        
        if dataNum == 0 {
            return tableView.frame.height
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //셀 데이터 입력
        guard let recivedData = self.recivedData else {
            return UITableViewCell()
        }
        
        let dataNum = self.recivedData?.fromQueueDBRequested.count ?? 0
        
        if dataNum == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.EmptySeSacTableViewCell.id) as? EmptySeSacTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        let row = recivedData.fromQueueDBRequested[indexPath.section]
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.CharactorTableViewCell.id) as? CharactorTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.backgroundImage.image = UIImage(named: "sesac_background_\(row.background + 1)")
            cell.charactorImage.image = UIImage(named: "sesac_face_\(row.sesac + 1)")
            cell.matchingButton.status = .accept
            
            cell.matchingButton.rx.tap
                .bind {
                    self.matchingButtonClicked(section: indexPath.section, row: indexPath.row)
                }.disposed(by: cell.bag)
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.CardTableViewCell.id) as? CardTableViewCell else { return UITableViewCell()}
            
            cell.nicknameLabel.text = "\(row.nick)"
            
            cell.selectionStyle = .none
            cell.titleCollectionView.tag = 101
            cell.hobbyCollectionView.tag = 102

            cell.updateCell(reputation: row.reputation, review: row.reviews, hobby: row.hf)
            
            cell.titleView.isHidden = self.moreButtonTapped[indexPath.section]
            cell.hobbyView.isHidden = self.moreButtonTapped[indexPath.section]
            cell.reviewView.isHidden = self.moreButtonTapped[indexPath.section]

            cell.moreButton.rx.tap
                .bind {
                    self.moreButtonClicked(section: indexPath.section, row: indexPath.row)
                }.disposed(by: cell.bag)
            
            //리뷰가 1개 이상일때만 reviewMoreButton을 보여줌
            if row.reviews.count > 1 {
                cell.reviewMoreButton.isHidden = false
            } else {
                cell.reviewMoreButton.isHidden = true
            }
            
            cell.reviewMoreButton.rx.tap
                .bind {
                    print(#function)
                    DispatchQueue.main.async {
                        let vc = ReviewDetailViewController()
                        vc.reviews = row.reviews
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }.disposed(by: cell.bag)

            
            return cell
        }
    }
}




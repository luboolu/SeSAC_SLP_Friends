//
//  NearSeSacViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/08.
//
import UIKit

import RxCocoa
import RxSwift
import Toast

final class NearSeSacViewController: UIViewController {
    
    private let mainView = NearSeSacView()
    private let viewModel = QueueViewModel()
    private let disposeBag = DisposeBag()
    private let toastStyle = ToastStyle()
    
    private var moreButtonTapped = [true, true, true]
    private var friendsNum = 3
    
    private var wantedHobby = [["코딩1", "iOS1","보드게임1"],["코딩2", "iOS2","보드게임2"],["코딩3", "iOS3","보드게임3"]]
    
    var nearData: [FromQueueDB]?
    var region: Int?
    var location: [Double]?
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        mainView.friendsTableView.delegate = self
        mainView.friendsTableView.dataSource = self
        
        //custom tableview cell register
        mainView.friendsTableView.register(CardTableViewCell.self, forCellReuseIdentifier: TableViewCell.CardTableViewCell.id)
        mainView.friendsTableView.register(CharactorTableViewCell.self, forCellReuseIdentifier: TableViewCell.CharactorTableViewCell.id)
        mainView.friendsTableView.register(EmptySeSacTableViewCell.self, forCellReuseIdentifier: TableViewCell.EmptySeSacTableViewCell.id)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
            self.findFriends()
            self.view.layoutIfNeeded()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("nearview!!!!")
        print(#function)
        print(nearData)
        
        findFriends()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("near view disappear")
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
                            self.nearData = []
                            
                            let genderFilter = UserDefaults.standard.integer(forKey: UserdefaultKey.genderFilter.rawValue)
                            for data in queueOnData.fromQueueDB {
                                if genderFilter == 2 {
                                    self.nearData?.append(data)
                                } else if genderFilter == data.gender {
                                    self.nearData?.append(data)
                                }
                            }
                            
                            if let nearData = self.nearData {
                                for _ in 0...nearData.count {
                                    self.moreButtonTapped.append(true)
                                }
                            }
                            
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
    
    func requestBeFriend(uid: String) {
        print(#function)
        viewModel.queueRequest(otherUID: uid) { apiResult, queueHobbyRequest in
            
            if let queueHobbyRequest = queueHobbyRequest {
                switch queueHobbyRequest {
                case .succeed:
                    DispatchQueue.main.async {
                        self.view.makeToast("취미 함께하기 요청을 보냈습니다" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    }
                case .requested:
                    //임시
                    //상대방도 이미 나에게 취미 함께하기 요청을 보낸 상태
                    //hobbyAccept 호출하고, 응답이 200이라면
                    //userdefault에 matching 상태 변경하고, 채팅화면으로 전환
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(matchingState.matched.rawValue, forKey: UserdefaultKey.matchingState.rawValue)

                        self.view.makeToast("상대방도 취미 함께하기를 요청했습니다. 채팅방으로 이동합니다" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    }
                case .stopped:
                    DispatchQueue.main.async {
                        self.view.makeToast("상대방이 취미 함께하기를 그만두었습니다" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    }
                case .tokenError:
                    self.requestBeFriend(uid: uid)
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
        
        let popUp = RequestPopUpViewController()
        popUp.mainTitle = "취미 같이 하기를 요청할게요!"
        popUp.subTitle = "요청이 수락되면 30분 후에 리뷰를 남길 수 있어요"
        popUp.friendUid = nearData?[section].uid
        popUp.modalPresentationStyle = .overCurrentContext
        popUp.modalTransitionStyle = .crossDissolve
        self.present(popUp, animated: true, completion: nil)
    }

    
    @objc private func updateMyState() {
        print(#function)
        
        viewModel.queueMyState { apiResult, queueState, myQueueState in
            if let queueState = queueState {
                switch queueState {
                case .succeed:
                    if let myQueueState = myQueueState {
                        print(myQueueState)
                        
                        if myQueueState.matched == 1 {
                            //매칭된 상태이므로 토스트 메세지를 띄우고, 채팅방으로 이동
                            self.view.makeToast("000님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다." ,duration: 2.0, position: .bottom, style: self.toastStyle)
                        }
                        
                    }
                case .stopped:
                    self.view.makeToast("오랜 시간 동안 매칭되지 않아 새싹 친구 찾기를 그만둡니다." ,duration: 2.0, position: .bottom, style: self.toastStyle)
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
                    self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                case .clientError:
                    self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                }
            }
        }
    }
}

extension NearSeSacViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let dataNum = self.nearData?.count ?? 0
        
        if dataNum == 0 {
            print("section 1개")
            return 1
        } else {
            return dataNum
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataNum = self.nearData?.count ?? 0
        
        if dataNum == 0 {
            print("row 1개")
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dataNum = self.nearData?.count ?? 0
        
        if dataNum == 0 {
            return tableView.frame.height
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //셀 데이터 입력
        guard let nearData = self.nearData else { return UITableViewCell() }
        
        let dataNum = self.nearData?.count ?? 0
        //데이터가 없으면 새싹이 없다는 뷰 보여주기
        if dataNum == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.EmptySeSacTableViewCell.id) as? EmptySeSacTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            
            return cell
        }

        let row = nearData[indexPath.section]
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.CharactorTableViewCell.id) as? CharactorTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.backgroundImage.image = UIImage(named: "sesac_background_\(row.background + 1)")
            cell.charactorImage.image = UIImage(named: "sesac_face_\(row.sesac + 1)")
            cell.matchingButton.status = .request
            
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
            print(row.hf)
            cell.updateCell(reputation: row.reputation, review: row.reviews, hobby: row.hf)
            print("\(row.nick): \(row.reviews)")
            
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




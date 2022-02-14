//
//  SeSacFindViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/08.
//

import UIKit

import RxCocoa
import RxSwift
import Toast

final class SeSacFindViewController: UIViewController {
    
    private let mainView = SeSacFindView()
    private let viewModel = QueueViewModel()
    private let disposeBag = DisposeBag()
    private let toastStyle = ToastStyle()
    
    private var nearVC = NearSeSacViewController()
    private var recivedVC = RecivedViewController()
    
    private var friendsData: QueueOnData?
    var region: Int?
    var location: [Double]?
    
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPagingButton()
        setButton()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor().black
        self.navigationItem.title = "새싹 찾기"
         
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(findStopButtonClicked))
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = UIColor().black
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        DispatchQueue.main.async {
            self.findFriends()
            self.nearViewButtonClicked()
        }
    }
    
    private func setPagingButton() {
        mainView.nearViewButton.rx.tap
            .scan(mainView.nearViewButton.status) { lastState, newState in
                self.mainView.recivedViewButton.status = .inactive
                self.nearViewButtonClicked()
                return .outline
            }
            .map{ $0 }
            .bind(to: mainView.nearViewButton.rx.status)
            .disposed(by: disposeBag)
        
        mainView.nearViewButton.rx.tap
            .scan(mainView.nearViewLine.status) { lastState, newState in
                self.mainView.recivedViewLine.status = .inactive
                return .fill
            }
            .map{ $0 }
            .bind(to: mainView.nearViewLine.rx.status)
            .disposed(by: disposeBag)
        
        mainView.recivedViewButton.rx.tap
            .scan(mainView.recivedViewButton.status) { lastState, newState in
                self.mainView.nearViewButton.status = .inactive
                self.recivedButtonClicked()
                return .outline
            }
            .map{ $0 }
            .bind(to: mainView.recivedViewButton.rx.status)
            .disposed(by: disposeBag)
        
        mainView.recivedViewButton.rx.tap
            .scan(mainView.recivedViewLine.status) { lastState, newState in
                self.mainView.nearViewLine.status = .inactive
                return .fill
            }
            .map{ $0 }
            .bind(to: mainView.recivedViewLine.rx.status)
            .disposed(by: disposeBag)

    }
    
    private func nearViewButtonClicked() {
        print(#function)
        //데이터 전달
        if let friendsData = friendsData {
            //nearVC.nearData = friendsData
            nearVC.region = self.region
            nearVC.location = self.location
        }
        print("subviews")
        print(mainView.contentView.subviews)
//        if mainView.contentView.subviews.count > 0 {
//            print(mainView.contentView.subviews)
//            print("remove")
//            self.recivedVC.view.removeFromSuperview()
//            self.recivedVC.removeFromParent()
//        }
        nearVC.view.frame = mainView.contentView.bounds
        mainView.contentView.addSubview(nearVC.view)
        self.addChild(nearVC)
        nearVC.didMove(toParent: self)
        
        self.reloadInputViews()
    }
    
    private func recivedButtonClicked() {
        print(#function)
        //데이터 전달
        if let friendsData = friendsData {
            recivedVC.recivedData = friendsData
        }
        
        if mainView.contentView.subviews.count > 0 {
            print("remove")
            self.nearVC.view.removeFromSuperview()
            self.nearVC.removeFromParent()
        }
        print(mainView.contentView.frame)
        print(mainView.contentView.bounds)
        recivedVC.view.frame = mainView.contentView.bounds
        mainView.contentView.addSubview(recivedVC.view)
        self.addChild(recivedVC)
        recivedVC.didMove(toParent: self)
        
        self.reloadInputViews()
    }
    
    private func setButton() {
        mainView.hobbyChangeButton.rx.tap
            .bind {
                print("hobbyChange")
            }.disposed(by: disposeBag)
        
        mainView.resetButton.rx.tap
            .bind {
                print("Reset")
            }.disposed(by: disposeBag)
    }
    
    private func findFriends() {
        guard let region = region, let location = location else {
            return
        }
        
        viewModel.queueStart(type: 2, region: region, lat: location[0], long: location[1], hobby: "anything") { apiResult, queueStart in
            if let queueStart = queueStart {
                switch queueStart {
                case .succeed:
                    print(queueStart)
                case .blocked:
                    return
                case .penaltyLv1:
                    return
                case .penaltyLv2:
                    return
                case .penaltyLv3:
                    return
                case .invalidGender:
                    return
                case .tokenError:
                    self.findFriends()
                case .notUser:
                    return
                case .serverError:
                    return
                case .clientError:
                    return
                }
            }
        }

        viewModel.queueOn(region: region, lat: location[0], long: location[1]) { apiResult, queueOn, queueOnData in
            print("새싹친구찾기 결과")
            print(queueOn)
            if let queueOn = queueOn {
                switch queueOn {
                case .succeed:
                    if let queueOnData = queueOnData {
                        DispatchQueue.main.async {
                            self.friendsData = queueOnData
                            //print(self.friendsData)
                            self.nearViewButtonClicked()
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
                    self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                case .clientError:
                    self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                }
            }
            
        }
    }
    
    private func updateMyState() {
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
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
            print("\(sender.selectedSegmentIndex)")
    }
    
    @objc private func findStopButtonClicked() {
        print(#function)
        //새싹찾기중단 api 호출 후 성공하면, 홈 화면으로 전환
        viewModel.queueEnd { apiResult, queueStop in
            if let queueStop = queueStop {
                switch queueStop {
                case .succeed:
                    DispatchQueue.main.async {
                        //userdefault matchingSate 값 변경
                        UserDefaults.standard.set(matchingState.noState.rawValue, forKey: UserdefaultKey.matchingState.rawValue)
                        //홈 화면으로 이동
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: MainViewController())
                        windowScene.windows.first?.makeKeyAndVisible()
                    }
                case .matched:
                    //토스트 메세지
                    self.view.makeToast("앗! 누군가가 나의 취미 함께 하기를 수락하였어요!", duration: 2.0, position: .bottom, style: self.toastStyle)
                    
                    //myQueueState api 호출
                    
                case .tokenError:
                    self.findStopButtonClicked()
                    return
                case .notUser:
                    //미가입 유저인 경우
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




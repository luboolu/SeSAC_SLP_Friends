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
    private var timer: Timer?
    
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
            self.nearViewButtonClicked()
        }
        
        if timer != nil && timer!.isValid {
            timer!.invalidate()
        }
        
        //5초마다 myQueueState 실행하여 데이터 갱신
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateMyState), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if timer != nil && timer!.isValid {
            timer!.invalidate()
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
        nearVC.region = self.region
        nearVC.location = self.location

        if mainView.contentView.subviews.count > 0 {
            print(mainView.contentView.subviews)
            print("remove")
            self.nearVC.view.removeFromSuperview()
            self.nearVC.removeFromParent()
            
            self.recivedVC.view.removeFromSuperview()
            self.recivedVC.removeFromParent()
        }
        
        nearVC.view.frame = mainView.contentView.bounds
        mainView.contentView.addSubview(nearVC.view)
        self.addChild(nearVC)
        nearVC.didMove(toParent: self)
        
        self.reloadInputViews()
    }
    
    private func recivedButtonClicked() {
        print(#function)
        //데이터 전달
        recivedVC.region = self.region
        recivedVC.location = self.location
        
        if mainView.contentView.subviews.count > 0 {
            print("remove")
            self.nearVC.view.removeFromSuperview()
            self.nearVC.removeFromParent()
            
            self.recivedVC.view.removeFromSuperview()
            self.recivedVC.removeFromParent()
        }

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
                self.hobbyChangeButtonClicked()
            }.disposed(by: disposeBag)
        
        mainView.resetButton.rx.tap
            .bind {
                print("Reset")
                self.resetButtonClicked()
            }.disposed(by: disposeBag)
    }
    
    private func hobbyChangeButtonClicked() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func resetButtonClicked() {
        print(mainView.contentView.subviews)
        if mainView.contentView.subviews.first == nearVC.view {
            self.nearViewButtonClicked()
        } else {
            self.recivedButtonClicked()
        }
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
                    DispatchQueue.main.async {
                        //토스트 메세지
                        self.view.makeToast("앗! 누군가가 나의 취미 함께 하기를 수락하였어요!", duration: 2.0, position: .bottom, style: self.toastStyle)
                        
                        //myQueueState api 호출
                    }
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
    
    @objc private func updateMyState() {
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
                                
                                //매칭 상태 변경
                                UserDefaults.standard.set(matchingState.matched.rawValue, forKey: UserdefaultKey.matchingState.rawValue)
                                //채팅 화면으로 전환
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




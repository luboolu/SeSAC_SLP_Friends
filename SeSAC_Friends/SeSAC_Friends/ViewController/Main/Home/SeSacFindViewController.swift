//
//  SeSacFindViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/08.
//

import UIKit

import RxCocoa
import RxSwift

final class SeSacFindViewController: UIViewController {
    
    private let mainView = SeSacFindView()
    private let viewModel = QueueViewModel()
    private let disposeBag = DisposeBag()
    
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
            nearVC.nearData = friendsData
        }
        
        if mainView.contentView.subviews.count > 0 {
            print("remove")
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
                    print("에러 잠시 후 시도 ㅂㅌ")
                case .clientError:
                    print("에러 잠시 후 시도 ㅂㅌ")
                }
            }
            
        }
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
            print("\(sender.selectedSegmentIndex)")
    }
    
    @objc private func findStopButtonClicked() {
        print(#function)
    }

    

}




//
//  HobbySearchViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/03.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class HobbySearchViewController: UIViewController {
    
    private let mainView = HobbySearchView()
    private let viewModel = QueueViewModel()
    private let disposeBag = DisposeBag()
    private let toastStyle = ToastStyle()
    
    private var myHobby: [String] = []
    private var recommandHobby: [String] = []
    private var nearHobby: [String] = []
    
    var userLocation: [Double]?
    var region: Int?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = mainView.searchBar
        
        setCollectionView()
        setSearchBar()
        setButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        searchHobby()

    }
    
    override func viewDidLayoutSubviews() {
        print(#function)
        super.viewDidLayoutSubviews()
        //cell의 갯수(높이)에 따라 collectionview의 height를 설정
        let nearHeight = mainView.nearCollectionView.collectionViewLayout.collectionViewContentSize.height
        mainView.nearCollectionView.snp.removeConstraints()
        mainView.nearCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(mainView.nearLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(nearHeight + 32)
        }
        
        let myHeight = mainView.myCollectionView.collectionViewLayout.collectionViewContentSize.height

        mainView.myCollectionView.snp.removeConstraints()
        mainView.myCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(mainView.myLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(myHeight + 32)
        }
        
        self.view.layoutIfNeeded()
    }
    
    private func setCollectionView() {
        mainView.nearCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        mainView.myCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        
        if let flowLayout = mainView.nearCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
          }
        if let flowLayout = mainView.myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
          }
        
        mainView.nearCollectionView.delegate = self
        mainView.nearCollectionView.dataSource = self
        mainView.myCollectionView.delegate = self
        mainView.myCollectionView.dataSource = self
        
        mainView.nearCollectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id)
        mainView.myCollectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id)

    }
    
    private func setSearchBar() {
        //searchBar 입력 끝 -> myCollectionView.reloadData()
        mainView.searchBar.rx.textDidEndEditing
            .bind {
                if let text = self.mainView.searchBar.text {
                    let splitText = text.split(separator: " ")
                    
                    for split in splitText {
                        //이미 추가된 취미는 추가되지 않도록
                        if self.myHobby.contains(String(split)) == false {
                            //이미 추가된 취미가 8개 이상이면 입력되지 않도록
                            if self.myHobby.count < 8 {
                                //8자리 이상의 취미는 입력하지 못하도록
                                if split.count <= 8 {
                                    self.myHobby.append(String(split))
                                } else {

                                }
                            } else {
                                //토스트 메세지
                                self.view.makeToast("취미를 더 이상 추가할 수 없습니다", duration: 2.0, position: .bottom, style: self.toastStyle)
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.mainView.searchBar.text = ""
                    self.mainView.myCollectionView.reloadData()
                    self.viewDidLayoutSubviews()
                }
            }
            .disposed(by: disposeBag)
        
        //키보드 return key 입력시, 내려가도록 함
        mainView.searchBar.rx.searchButtonClicked
            .bind {
                self.mainView.searchBar.resignFirstResponder()
            }
            .disposed(by: disposeBag)
    }
    
    private func setButton() {
        mainView.findButton.rx.tap
            .bind {
                self.findButtonClicked()
            }.disposed(by: disposeBag)
        
        mainView.accFindButton.rx.tap
            .bind {
                self.findButtonClicked()
            }.disposed(by: disposeBag)
    }
    
    private func findButtonClicked() {
        print(#function)
        
        guard let userLocation = userLocation, let region = region else {
            return
        }
        
        var hf = ""
        for hobby in myHobby {
            hf.append("\(hobby), ")
        }

        viewModel.queueStart(type: 2, region: region, lat: userLocation[0], long: userLocation[1], hobby: "anything") { apiResult, queueStart in
            print(queueStart)
            if let queueStart = queueStart {
                switch queueStart {
                case .succeed:
                    DispatchQueue.main.async {
                        //userdefault matchingSate 값 변경
                        UserDefaults.standard.set(matchingState.waiting.rawValue, forKey: UserdefaultKey.matchingState.rawValue)
                        
                        let vc = SeSacFindViewController()
                        vc.location = [userLocation[0], userLocation[1]]
                        vc.region = region
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                case .blocked:
                     print("blocked")
                case .penaltyLv1:
                    print("penaltyLv1")
                case .penaltyLv2:
                    print("penaltyLv2")
                case .penaltyLv3:
                    print("penaltyLv3")
                case .invalidGender:
                    print("invalidGender")
                case .tokenError:
                    print("tokenError")
                case .notUser:
                    print("notUser")
                case .serverError:
                    print("serverError")
                case .clientError:
                    print("clientError")
                }
            }
        }
    }
    
    private func searchHobby() {
        
        if let region = region, let userLocation = userLocation {
            
            viewModel.queueOn(region: region, lat: userLocation[0], long: userLocation[1]) { apiResult, queueOn, queueOnData in
                if let queueOn = queueOn {
                    switch queueOn {
                    case .succeed:
                        if let queueOnData = queueOnData {
                            self.recommandHobby = queueOnData.fromRecommend
                            var near: [String] = []
                            
                            for data in queueOnData.fromQueueDB {
                                for hf in data.hf {
                                    near.append(hf)
                                }
                            }
                            
                            self.nearHobby = near
                            print("추천: \(self.recommandHobby)")
                            print("주변: \(near)")
                            
                            //collectionView reload
                            DispatchQueue.main.async {
                                self.mainView.nearCollectionView.reloadData()
                                self.viewDidLayoutSubviews()
                            }
                            
                        }
                    case .tokenError:
                        self.searchHobby()
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
        
    }
    
    
    
}

extension HobbySearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.mainView.nearCollectionView {
            //return self.nearHobby.count + self.recommandHobby.count
            return (self.nearHobby.count + self.recommandHobby.count) > 8 ? 8 : (self.nearHobby.count + self.recommandHobby.count)
        } else {
            return self.myHobby.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == self.mainView.nearCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id, for: indexPath) as? ButtonCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.button.snp.makeConstraints { make in
                make.height.equalTo(32)
            }

            
            let count = self.nearHobby.count + self.recommandHobby.count
            
            if indexPath.row < self.recommandHobby.count {
                cell.button.setTitle("\(self.recommandHobby[indexPath.row])", for: .normal)
                cell.button.status = .focus
            } else {
                cell.button.setTitle("\(self.nearHobby[count - indexPath.row - 1])", for: .normal)
                cell.button.status = .inactive
            }
            
            cell.button.rx.tap.asDriver()
                .throttle(.seconds(1))
                .drive(onNext: { _ in
                    DispatchQueue.main.async {
                        if let selected = cell.button.titleLabel?.text {
                            if self.myHobby.contains(selected) == false {
                                if self.myHobby.count < 8 {
                                    self.myHobby.append("\(cell.button.titleLabel?.text ?? "")")
                                    self.mainView.myCollectionView.reloadData()
                                    self.viewDidLayoutSubviews()
                                } else {
                                    self.view.makeToast("취미를 더 이상 추가할 수 없습니다", duration: 2.0, position: .bottom, style: self.toastStyle)
                                }
                            }
                        }
                    }
                }).disposed(by: cell.bag)

            
            return cell
        } else {
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id, for: indexPath) as? ButtonCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.button.snp.makeConstraints { make in
                make.height.equalTo(32)
            }

            cell.button.setTitle("\(self.myHobby[indexPath.row])", for: .normal)
            cell.button.status = .outline
            cell.button.imageStyle = .close_color
            cell.button.isEnabled = true
            
            cell.button.rx.tap.asDriver()
                .throttle(.seconds(1))
                .drive(onNext: { _ in
                    DispatchQueue.main.async {
                        self.myHobby.remove(at: indexPath.row)
                        self.mainView.myCollectionView.reloadData()
                        self.viewDidLayoutSubviews()
                    }
                }).disposed(by: cell.bag)

            return cell
        }
        
    }
    
}

extension HobbySearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == mainView.nearCollectionView {
            let button = UIButton(frame: CGRect.zero)
            
            let count = self.nearHobby.count + self.recommandHobby.count
            
            if indexPath.row < self.recommandHobby.count {
                button.setTitle("\(self.recommandHobby[indexPath.row])", for: .normal)
            } else {
                button.setTitle("\(self.nearHobby[count - indexPath.row - 1])", for: .normal)
            }

            button.sizeToFit()

            return CGSize(width: button.frame.width + 32, height: 32)
        } else {
            let button = UIButton(frame: CGRect.zero)
            button.setTitle("\(self.myHobby[indexPath.row])", for: .normal)
            button.setImage(UIImage(named: "close_color"), for: .normal)
            button.sizeToFit()
            
            return CGSize(width: button.frame.width + 32, height: 32)
        }

    }

}


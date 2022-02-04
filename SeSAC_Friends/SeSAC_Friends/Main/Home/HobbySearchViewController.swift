//
//  HobbySearchViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/03.
//

import UIKit

import RxCocoa
import RxSwift

class HobbySearchViewController: UIViewController {
    
    let mainView = HobbySearchView()
    let disposeBag = DisposeBag()
    
    let nearHobbyList = ["아무거나", "SeSAC", "코딩", "맛집탐방", "공원산책", "독서모임", "식물", "카페투어"]
    var myHobbyList: [String] = []
//    var myHobbyList = ["코딩", "클라이밍", "달리기", "오일파스텔", "축구", "배드민턴", "테니스"]
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = mainView.searchBar
        setCollectionView()
        setSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        print(#function)
        super.viewDidLayoutSubviews()
        //cell의 갯수(높이)에 따라 collectionview의 height를 설정
        let nearHeight = mainView.nearCollectionView.collectionViewLayout.collectionViewContentSize.height
        mainView.nearCollectionView.snp.makeConstraints { make in
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
    
    func setCollectionView() {
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
    
    func setSearchBar() {
        //searchBar 입력 끝 -> myCollectionView.reloadData()
        mainView.searchBar.rx.textDidEndEditing
            .bind {
                if let text = self.mainView.searchBar.text {
                    let splitText = text.split(separator: " ")
                    
                    for split in splitText {
                        //이미 추가된 취미는 추가되지 않도록
                        if self.myHobbyList.contains(String(split)) == false {
                            self.myHobbyList.append(String(split))
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
    }
    
    @objc func myHobbyDelete() {
        print("my hobby tapped ")
//        print(self.myHobbyList)
//        self.myHobbyList.remove(at: index)
//        print(self.myHobbyList)
//        DispatchQueue.main.async {
//            self.mainView.myCollectionView.reloadData()
//        }
    }
}

extension HobbySearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.mainView.nearCollectionView {
            return self.nearHobbyList.count
        } else {
            return self.myHobbyList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == self.mainView.nearCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id, for: indexPath) as? ButtonCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.button.setTitle("\(self.nearHobbyList[indexPath.row])", for: .normal)
            
            if indexPath.row > 2 {
                cell.button.status = .inactive
            } else {
                cell.button .status = .focus
            }
            
            return cell
        } else {
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id, for: indexPath) as? ButtonCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.button.snp.makeConstraints { make in
                make.height.equalTo(32)
            }

            //cell.button.setTitle("\(self.myHobbyList[indexPath.row])", for: .normal)
            cell.button.setTitle("\(indexPath.row)", for: .normal)
            cell.button.status = .outline
            cell.button.imageStyle = .close_color
            
            cell.button.addTarget(self, action: #selector(myHobbyDelete), for: .touchUpInside)
//            cell.button.rx.tap
//                .bind {
//                    print("my hobby tapped \(indexPath.row)")
//                    print(self.myHobbyList)
//                    self.myHobbyList.remove(at: indexPath.row)
//                    print(self.myHobbyList)
//                    DispatchQueue.main.async {
//                        self.mainView.myCollectionView.reloadData()
//                    }
//                }.disposed(by: disposeBag)

            
            return cell
        }
    }

}

extension HobbySearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == mainView.nearCollectionView {
            let button = UIButton(frame: CGRect.zero)
            button.setTitle("\(self.nearHobbyList[indexPath.row])", for: .normal)
            button.sizeToFit()
            
            return CGSize(width: button.frame.width + 32, height: 32)
        } else {
            let button = UIButton(frame: CGRect.zero)
            button.setTitle("\(self.myHobbyList[indexPath.row])", for: .normal)
            button.setImage(UIImage(named: "close_color"), for: .normal)
            button.sizeToFit()
            
            return CGSize(width: button.frame.width + 32, height: 32)
        }

    }

}

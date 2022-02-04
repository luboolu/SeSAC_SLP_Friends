//
//  HobbySearchViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/03.
//

import UIKit

import RxCocoa
import RxSwift

final class HobbySearchViewController: UIViewController {
    
    private let mainView = HobbySearchView()
    private let disposeBag = DisposeBag()
    
    private let nearHobbyList = ["아무거나", "SeSAC", "코딩", "맛집탐방", "공원산책", "독서모임", "식물", "카페투어"]
    private var myHobbyList: [String] = []
    
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

            cell.button.setTitle("\(self.myHobbyList[indexPath.row])", for: .normal)
            cell.button.status = .outline
            cell.button.imageStyle = .close_color
            cell.button.isEnabled = true
            
            cell.button.rx.tap.asDriver()
                .throttle(.seconds(1))
                .drive(onNext: { _ in
                    DispatchQueue.main.async {
                        self.myHobbyList.remove(at: indexPath.row)
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

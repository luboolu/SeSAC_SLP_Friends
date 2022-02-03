//
//  HobbySearchViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/03.
//

import UIKit

class HobbySearchViewController: UIViewController {
    
    let mainView = HobbySearchView()
    
    let nearHobbyList = ["아무거나", "SeSAC", "코딩", "맛집탐방", "공원산책", "독서모임", "식물", "카페투어"]
    let myHobbyList = ["코딩", "클라이밍", "달리기", "오일파스텔", "축구", "배드민턴", "테니스"]
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = mainView.searchBar
        
        mainView.nearCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        if let flowLayout = mainView.nearCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
          }
        
        mainView.nearCollectionView.delegate = self
        mainView.nearCollectionView.dataSource = self
        
        mainView.nearCollectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id)
        
        mainView.myCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        if let flowLayout = mainView.myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
          }
        
        mainView.myCollectionView.delegate = self
        mainView.myCollectionView.dataSource = self
        
        mainView.myCollectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id)
        
        mainView.nearCollectionView.snp.makeConstraints { make in
            //make.height.equalTo(200)
        }
        
        //mainView.nearCollectionView.contentSize = CGSize(width: mainView.nearCollectionView.frame.width, height: 100)
        
        mainView.nearCollectionView.invalidateIntrinsicContentSize()
        mainView.myCollectionView.invalidateIntrinsicContentSize()
        
        mainView.nearCollectionView.layoutIfNeeded()
        mainView.myCollectionView.layoutIfNeeded()
    

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
        print(collectionView)
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

            cell.button.setTitle("\(self.myHobbyList[indexPath.row])", for: .normal)
            
            if indexPath.row > 2 {
                cell.button.status = .inactive
            } else {
                cell.button .status = .focus
            }
            
            return cell
        }
    }

//estimated: 속성 찾아보기 -> 
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
            button.sizeToFit()
            
            return CGSize(width: button.frame.width + 32, height: 32)
        }

    }

}

//
//  NearSeSacViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/08.
//
import UIKit

import RxCocoa
import RxSwift

final class NearSeSacViewController: UIViewController {
    
    private let mainView = NearSeSacView()
    private let disposeBag = DisposeBag()
    
    private var moreButtonTapped = [true, true, true]
    private var friendsNum = 3
    
    private var wantedHobby = ["코딩", "iOS","보드게임"]
    
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
    }
    
    @objc func moreButtonClicked() {
        print("moreButton tapped")
        //self.moreButtonTapped = !self.moreButtonTapped
        self.mainView.friendsTableView.reloadRows(at: [[0, 1]], with: .fade)
    }
    
    func moreButton(section: Int, row: Int) {
        self.moreButtonTapped[section] = !self.moreButtonTapped[section]
        self.mainView.friendsTableView.reloadRows(at: [[section, row]], with: .fade)
    }
}

extension NearSeSacViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.friendsNum
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.CharactorTableViewCell.id) as? CharactorTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.backgroundImage.image = UIImage(named: "sesac_background_1")
            cell.charactorImage.image = UIImage(named: "sesac_face_1")
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.CardTableViewCell.id) as? CardTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.titleCollectionView.delegate = self
            cell.titleCollectionView.dataSource = self
            cell.titleCollectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id)
            cell.titleCollectionView.tag = 101
            
            cell.hobbyView.backgroundColor = UIColor().gray5
            cell.hobbyCollectionView.delegate = self
            cell.hobbyCollectionView.dataSource = self
            cell.hobbyCollectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id)
            cell.hobbyCollectionView.tag = 102
            
            cell.nicknameLabel.text = "바바유"
            
            cell.titleView.isHidden = self.moreButtonTapped[indexPath.section]
            cell.hobbyView.isHidden = self.moreButtonTapped[indexPath.section]
            cell.reviewView.isHidden = self.moreButtonTapped[indexPath.section]
            
//            cell.moreButton.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)
            cell.moreButton.rx.tap
                .bind {
                    self.moreButton(section: indexPath.section, row: indexPath.row)
                }.disposed(by: cell.bag)

            
            return cell
        }
    }
}


extension NearSeSacViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 101 {
            return 6
        } else {
            return self.wantedHobby.count
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        
        if collectionView.tag == 101 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id, for: indexPath) as? ButtonCollectionViewCell else { return UICollectionViewCell() }
            
            let titleList = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 취미 실력", "유익한 시간"]
            
            cell.button.setTitle("\(titleList[indexPath.row])", for: .normal)
            cell.button.isEnabled = false
            cell.button.status = .inactive
            
    //        if let data = self.myInfo {
    //            if data.reputation[indexPath.row] == 0 {
    //                cell.button.status = .inactive
    //            } else {
    //                cell.button.status = .fill
    //            }
    //        }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id, for: indexPath) as? ButtonCollectionViewCell else { return UICollectionViewCell() }
            
            cell.button.setTitle("\(self.wantedHobby[indexPath.row])", for: .normal)
            cell.button.isEnabled = false
            cell.button.status = .inactive
            
    //        if let data = self.myInfo {
    //            if data.reputation[indexPath.row] == 0 {
    //                cell.button.status = .inactive
    //            } else {
    //                cell.button.status = .fill
    //            }
    //        }
            
            return cell
        }

    }
}

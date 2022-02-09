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
    
    private var moreButtonTapped = true
    
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
        self.moreButtonTapped = !self.moreButtonTapped
        self.mainView.friendsTableView.reloadRows(at: [[0, 1]], with: .fade)
    }
}

extension NearSeSacViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
            
            cell.nicknameLabel.text = "바바유"
            
            cell.titleView.isHidden = self.moreButtonTapped
            cell.hobbyView.isHidden = self.moreButtonTapped
            cell.reviewView.isHidden = self.moreButtonTapped

//            cell.moreButton.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)

            cell.moreButton.rx.tap
                .scan(false) { lastState, newState in
                    return !lastState
                }.map { $0 }
                .bind(to: cell.moreButton.rx.isSelected)
                .disposed(by: cell.bag)
//
            cell.moreButton.rx.tap
                .bind {
                    print(cell.moreButton.isSelected)
                    self.moreButtonClicked()
                }.disposed(by: cell.bag)
            
//            cell.moreButton.rx.tap
//                .bind {
//                    print(cell.moreButton.isSelected)
//                    cell.titleView.isHidden = cell.moreButton.isSelected
//                    cell.hobbyView.isHidden = cell.moreButton.isSelected
//                    cell.reviewView.isHidden = cell.moreButton.isSelected
//                    DispatchQueue.main.async {
//                        //self.mainView.friendsTableView.reloadData()
//                        //self.mainView.friendsTableView.reloadRows(at: [[0,1]], with: .automatic)
//                    }
//                }.disposed(by: cell.bag)


            
//            cell.moreButton.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)

            
            return cell
        }
    }
}


extension NearSeSacViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id, for: indexPath) as? ButtonCollectionViewCell else { return UICollectionViewCell() }
        
        //cell.backgroundColor = UIColor().green
        
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
    }
}

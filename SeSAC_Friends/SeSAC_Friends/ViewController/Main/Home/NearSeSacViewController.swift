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
    
    private var wantedHobby = [["코딩1", "iOS1","보드게임1"],["코딩2", "iOS2","보드게임2"],["코딩3", "iOS3","보드게임3"]]
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        

    }
    
    @objc func moreButtonClicked() {
        print("moreButton tapped")
        //self.moreButtonTapped = !self.moreButtonTapped
        self.mainView.friendsTableView.reloadRows(at: [[0, 1]], with: .fade)
    }
    
    func moreButton(section: Int, row: Int) {
        self.moreButtonTapped[section] = !self.moreButtonTapped[section]
        self.mainView.friendsTableView.reloadRows(at: [[section, row]], with: .fade)
        self.viewDidLayoutSubviews()
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
            cell.titleCollectionView.tag = 101
            cell.hobbyCollectionView.tag = 102
            
            cell.updateCell(row: self.wantedHobby[indexPath.section])
            
            if let flowLayout = cell.hobbyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
              }
            
            cell.nicknameLabel.text = "\(indexPath)"
            
            cell.titleView.isHidden = self.moreButtonTapped[indexPath.section]
            cell.hobbyView.isHidden = self.moreButtonTapped[indexPath.section]
            cell.reviewView.isHidden = self.moreButtonTapped[indexPath.section]

            cell.moreButton.rx.tap
                .bind {
                    self.moreButton(section: indexPath.section, row: indexPath.row)
                }.disposed(by: cell.bag)

            
            return cell
        }
    }
}




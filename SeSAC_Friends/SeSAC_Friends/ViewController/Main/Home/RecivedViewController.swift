//
//  RecivedViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/08.
//
import UIKit

import RxCocoa
import RxSwift

final class RecivedViewController: UIViewController {
    
    private let mainView = RecivedView()
    private let disposeBag = DisposeBag()
    
    private var moreButtonTapped = [true, true, true]
    private var friendsNum = 3
    
    private var wantedHobby = [["코딩1", "iOS1","보드게임1"],["코딩2", "iOS2","보드게임2"],["코딩3", "iOS3","보드게임3"]]
    
    var recivedData: QueueOnData?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        print(recivedData)
        
        if let recivedData = recivedData {
            self.moreButtonTapped.removeAll()
            
            for i in 0...recivedData.fromQueueDBRequested.count {
                self.moreButtonTapped.append(true)
            }
        }
        
        self.mainView.friendsTableView.reloadData()
    }
    
    func moreButtonClicked(section: Int, row: Int) {
        self.moreButtonTapped[section] = !self.moreButtonTapped[section]
        self.mainView.friendsTableView.reloadRows(at: [[section, row]], with: .fade)
        self.viewDidLayoutSubviews()
    }
    
    func matchingButtonClicked(section: Int, row: Int) {
        print(#function)
    }
    
    
}

extension RecivedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.recivedData?.fromQueueDBRequested.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //셀 데이터 입력
        guard let recivedData = self.recivedData else { return UITableViewCell() }
        let row = recivedData.fromQueueDBRequested[indexPath.section]
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.CharactorTableViewCell.id) as? CharactorTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.backgroundImage.image = UIImage(named: "sesac_background_1")
            cell.charactorImage.image = UIImage(named: "sesac_face_1")
            cell.matchingButton.status = .accept
            
            cell.matchingButton.rx.tap
                .bind {
                    self.matchingButtonClicked(section: indexPath.section, row: indexPath.row)
                }.disposed(by: cell.bag)
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.CardTableViewCell.id) as? CardTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.titleCollectionView.tag = 101
            cell.hobbyCollectionView.tag = 102
            
            //cell.updateCell(row: self.wantedHobby[indexPath.section])
            cell.updateCell(reputation: row.reputation, review: row.reviews, hobby: row.hf)
            
            cell.nicknameLabel.text = "\(indexPath)"
            
            cell.titleView.isHidden = self.moreButtonTapped[indexPath.section]
            cell.hobbyView.isHidden = self.moreButtonTapped[indexPath.section]
            cell.reviewView.isHidden = self.moreButtonTapped[indexPath.section]

            cell.moreButton.rx.tap
                .bind {
                    self.moreButtonClicked(section: indexPath.section, row: indexPath.row)
                }.disposed(by: cell.bag)
            
            //셀 데이터 입력
            if let recivedData = self.recivedData {
                let row = recivedData.fromQueueDBRequested[indexPath.section]
                cell.nicknameLabel.text = "\(row.nick)"
            }

            
            return cell
        }
    }
}




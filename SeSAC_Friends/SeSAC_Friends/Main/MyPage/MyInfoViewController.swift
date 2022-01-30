//
//  MyInfoViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/26.
//

import UIKit

import RxCocoa
import RxSwift
import MultiSlider

class MyInfoViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.estimatedRowHeight = 88
        
        return tableView
    }()
    
    let disposeBag = DisposeBag()
    
    var moreButtonTabbed = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.tintColor = UIColor().black
        self.navigationItem.title = "정보 관리"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
    }
    
    func setUp() {
        view.backgroundColor = UIColor().white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TwoButtonTableViewCell.self, forCellReuseIdentifier: TableViewCell.TwoButtonTableViewCell.id)
        tableView.register(TextfieldTableViewCell.self, forCellReuseIdentifier: TableViewCell.TextfieldTableViewCell.id)
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: TableViewCell.SwitchTableViewCell.id)
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: TableViewCell.LabelTableViewCell.id)
        tableView.register(DoubleSliderTableViewCell.self, forCellReuseIdentifier: TableViewCell.DoubleSliderTableViewCell.id)
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: TableViewCell.CardTableViewCell.id)
        tableView.register(CharactorTableViewCell.self, forCellReuseIdentifier: TableViewCell.CharactorTableViewCell.id)
        
        view.addSubview(tableView)
    }
    
    func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
        
    @objc func saveButtonClicked() {
        print(#function)
    }
    
    @objc func sliderChanged(_ slider: MultiSlider) {
        print("thumb \(slider.draggedThumbIndex) moved")
        print("now thumbs are at \(slider.value)") // e.g., [1.0, 4.5, 5.0]
    }
    
    @objc func moreButtonClicked() {
        print("moreButton tapped")
        self.moreButtonTabbed = !self.moreButtonTabbed
        self.tableView.reloadRows(at: [[0,1]], with: .fade)
    }
}

extension MyInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    //tableView Header View
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = CharactorView()
//        headerView.backgroundImage.image = UIImage(named: "sesac_background_1")
//        headerView.charactorImage.image = UIImage(named: "sesac_face_1")
//        headerView.layer.masksToBounds = true
//        headerView.layer.cornerRadius = 10
//
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.CharactorTableViewCell.id) as? CharactorTableViewCell else { return UITableViewCell()}
            
            cell.backgroundImage.image = UIImage(named: "sesac_background_1")
            cell.charactorImage.image = UIImage(named: "sesac_face_1")

            
            return cell
            
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.CardTableViewCell.id) as? CardTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.titleCollectionView.delegate = self
            cell.titleCollectionView.dataSource = self
            cell.titleCollectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id)
            
            cell.nicknameLabel.text = "고래밥"
            cell.titleView.isHidden = self.moreButtonTabbed
            cell.hobbyView.isHidden = true
            cell.reviewView.isHidden = self.moreButtonTabbed

            cell.moreButton.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)

            
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.TwoButtonTableViewCell.id) as? TwoButtonTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.label.text = "내 성별"

            cell.manButton.rx.tap
                .bind { _ in
                    cell.manButton.isSelected = !cell.manButton.isSelected
                    print(cell.manButton.isSelected)
                    
                    if cell.manButton.isSelected {
                        cell.manButton.status = .fill
                    } else {
                        cell.manButton.status = .inactive
                    }
                    cell.womanButton.isSelected = false
                    cell.womanButton.status = .inactive
                    
                    print("man: \(cell.manButton.isSelected) woman: \(cell.womanButton.isSelected)")
                }
            
            cell.womanButton.rx.tap
                .bind { _ in
                    cell.womanButton.isSelected = !cell.womanButton.isSelected
                    print(cell.womanButton.isSelected)
                    
                    if cell.womanButton.isSelected {
                        cell.womanButton.status = .fill
                    } else {
                        cell.womanButton.status = .inactive
                    }
                    cell.manButton.isSelected = false
                    cell.manButton.status = .inactive
                    
                    print("man: \(cell.manButton.isSelected) woman: \(cell.womanButton.isSelected)")
                }
            
            return cell
            
        }  else if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.TextfieldTableViewCell.id) as? TextfieldTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.label.text = "자주 하는 취미"
            cell.textfield.textfield.placeholder = "취미를 입력해주세요"
            
            return cell
            
        } else if indexPath.row == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.SwitchTableViewCell.id) as? SwitchTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.label.text = "내 번호 검색 허용"
            
            return cell
            
        }  else if indexPath.row == 5 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.DoubleSliderTableViewCell.id) as? DoubleSliderTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.label.text = "상대방 연령대"
            cell.ageLabel.text = "18-35"
            
            cell.slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.LabelTableViewCell.id) as? LabelTableViewCell else { return UITableViewCell()}
            
            cell.label.text = "회원탈퇴"
            
            return cell
            
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}

extension MyInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id, for: indexPath) as? ButtonCollectionViewCell else { return UICollectionViewCell() }
        
        //cell.backgroundColor = UIColor().green
        
        let titleList = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 취미 실력", "유익한 시간"]
        
        cell.button.setTitle("\(titleList[indexPath.row])", for: .normal)
        
        cell.button.rx.tap
            .bind {
                cell.button.status = .fill
            }
        
        return cell
    }
}

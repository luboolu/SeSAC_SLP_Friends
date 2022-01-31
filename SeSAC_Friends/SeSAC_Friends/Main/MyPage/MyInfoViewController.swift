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
    
    let mainView = MyInfoView()
    let viewModel = UserViewModel()
    let disposeBag = DisposeBag()
    
    var moreButtonTabbed = true
    var preferredAgeGroup = [18, 35]
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        self.viewModel.getUser() { statusCode, result in
            print("statusCode: \(statusCode)")
            
            DispatchQueue.main.async {
                //유저정보 가져오는데 성공한 경우
                if statusCode == 200 {
                    print(result)
                    
                } else if statusCode == 201 {

                } else if statusCode == 401 {
                    //firebase token 만료
                    //토큰 갱신해야함
                    self.viewModel.idTokenRequest { error in
                        print(error)
                        if error == nil {
                            print("토큰 갱신 성공")
                        }
                    }
                }
            }

            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.tintColor = UIColor().black
        self.navigationItem.title = "정보 관리"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
    }
        
    @objc func saveButtonClicked() {
        print(#function)
        //정보관리 뷰의 저장 버튼이 클릭 -> 각 테이블뷰 셀의 값을 서버에 업데이트 할 수 있게 해야함
        //1. 테이블뷰의 데이터 가져오기
        //2. api 통신
        
        
        //1.
        //tableview indexPath [0,2] ~ [0,6]
        
    }
    
    @objc func sliderChanged(_ slider: MultiSlider) {
        self.preferredAgeGroup[0] = Int(slider.value[0])
        self.preferredAgeGroup[1] = Int(slider.value[1])
        
        self.mainView.tableView.reloadRows(at: [[0, 5]], with: .none)
    }
    
    @objc func moreButtonClicked() {
        print("moreButton tapped")
        self.moreButtonTabbed = !self.moreButtonTabbed
        self.mainView.tableView.reloadRows(at: [[0, 1]], with: .fade)
    }
}

extension MyInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
            cell.slider.value = [CGFloat(self.preferredAgeGroup[0]), CGFloat(self.preferredAgeGroup[1])]
            
            cell.label.text = "상대방 연령대"
            cell.ageLabel.text = "\(self.preferredAgeGroup[0])-\(self.preferredAgeGroup[1])"
            
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

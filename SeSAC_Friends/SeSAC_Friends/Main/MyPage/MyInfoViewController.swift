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
    var disposeBag = DisposeBag()
    
    var moreButtonTabbed = true
    var myInfo: UserInfo?
    
    //tableview에서 선택된 값
    var myGender = -1
    var myHobby = ""
    var myNumberSearch = 0
    var myPreferredAge = [18, 35]
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        getUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.tintColor = UIColor().black
        self.navigationItem.title = "정보 관리"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
    }
    
    func getUserInfo() {
        print(#function)
        
        self.viewModel.getUser() { statusCode, result in
            DispatchQueue.main.async {
                print("statusCode: \(statusCode)")
                
                //유저정보 가져오는데 성공한 경우
                if statusCode == 200 {
                    if let result = result {
                        print(result)
                        self.myInfo = result
                        
                        self.myGender = result.gender
                        self.myHobby = result.hobby
                        self.myNumberSearch = result.searchable
                        self.myPreferredAge = [result.ageMin, result.ageMax]
                        
                        self.mainView.tableView.reloadData()
                    }
                    
                } else if statusCode == 201 {

                } else if statusCode == 401 {
                    //firebase token 만료
                    //토큰 갱신해야함
                    print("idtoken 갱신 필요")
                    self.reloadIdToken()
                    //return
                }
            }
        }
    }
    
    func reloadIdToken() {
        self.viewModel.idTokenRequest { error in
            DispatchQueue.main.async {
                print(error)
                if error == nil {
                    print("토큰 갱신 성공")
                    //갱신된 토큰으로 다시 유저 정보 요청
                    self.getUserInfo()
                }
            }
        }

    }
    
    func userWithdrawRequest() {
        //회원탈퇴 api 통신
    }

        
    @objc func saveButtonClicked() {
        print(#function)
        //정보관리 뷰의 저장 버튼이 클릭 -> 각 테이블뷰 셀의 값을 서버에 업데이트 할 수 있게 해야함
        //1. 테이블뷰의 데이터 가져오기
        //2. api 통신
        
        print("myGender: \(myGender) myHobby: \(myHobby) myNumberSearch: \(myNumberSearch) myPreferredAge: \(myPreferredAge)")
        //1.
        //tableview indexPath [0,2] ~ [0,6]
        
        
    }
    
    @objc func sliderChanged(_ slider: MultiSlider) {
        self.myPreferredAge[0] = Int(slider.value[0])
        self.myPreferredAge[1] = Int(slider.value[1])
        
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
            
            if let data = self.myInfo {
                cell.nicknameLabel.text = data.nick
            }
            
            cell.titleView.isHidden = self.moreButtonTabbed
            cell.hobbyView.isHidden = true
            cell.reviewView.isHidden = self.moreButtonTabbed

            cell.moreButton.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)

            
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.TwoButtonTableViewCell.id) as? TwoButtonTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.label.text = "내 성별"
            
            if self.myGender == 0 {
                cell.womanButton.status = .fill
            } else if self.myGender == 1 {
                cell.manButton.status = .fill
            } else {
                cell.womanButton.status = .inactive
                cell.manButton.status = .inactive
            }
            
            cell.manButton.rx.tap
                .scan(cell.manButton.status) { lastState, newState in
                    cell.womanButton.status = .inactive
                    self.myGender = 1
                    return .fill
                }
                .map { $0 }
                .bind(to: cell.manButton.rx.status)
                .disposed(by: self.disposeBag)
            
            cell.womanButton.rx.tap
                .scan(cell.womanButton.status) { lastState, newState in
                    cell.manButton.status = .inactive
                    self.myGender = 0
                    return .fill
                }
                .map { $0 }
                .bind(to: cell.womanButton.rx.status)
                .disposed(by: self.disposeBag)

            
            return cell
            
        }  else if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.TextfieldTableViewCell.id) as? TextfieldTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.label.text = "자주 하는 취미"
            cell.textfield.textfield.placeholder = "취미를 입력해주세요"
            cell.textfield.textfield.text = self.myHobby
            
            //textfield가 활성화되는 시점을 감지
            cell.textfield.textfield.rx.controlEvent([.editingDidBegin])
                .asObservable()
                .subscribe(onNext: { _ in
                    cell.textfield.status = .active
                    cell.textfield.textfield.placeholder = "취미를 입력해주세요"
                }).disposed(by: disposeBag)
            
            //textfield가 비활성화 되는 시점을 감지
            cell.textfield.textfield.rx.controlEvent([.editingDidEnd])
                .asObservable()
                .subscribe(onNext: { _ in
                    cell.textfield.status = .inactive
                    cell.textfield.textfield.placeholder = "취미를 입력해주세요"
                    self.myHobby = cell.textfield.textfield.text ?? ""
                }).disposed(by: disposeBag)
            
            return cell
            
        } else if indexPath.row == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.SwitchTableViewCell.id) as? SwitchTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.label.text = "내 번호 검색 허용"
            
            if self.myNumberSearch == 1 {
                cell.switchButton.isOn = true
            } else {
                cell.switchButton.isOn = false
            }
            
            cell.switchButton.rx.controlEvent([.valueChanged])
                .subscribe { _ in
                    if cell.switchButton.isOn == true {
                        self.myNumberSearch = 1
                    } else {
                        self.myNumberSearch = 0
                    }
                    
                }
                .disposed(by: self.disposeBag)
            
            return cell
            
        }  else if indexPath.row == 5 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.DoubleSliderTableViewCell.id) as? DoubleSliderTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.slider.value = [CGFloat(self.myPreferredAge[0]), CGFloat(self.myPreferredAge[1])]
            
            cell.label.text = "상대방 연령대"
            cell.ageLabel.text = "\(self.myPreferredAge[0])-\(self.myPreferredAge[1])"
            
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

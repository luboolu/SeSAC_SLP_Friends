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
import Toast

final class MyInfoViewController: UIViewController {
    
    private let mainView = MyInfoView()
    private let viewModel = UserViewModel()
    private let toastStyle = ToastStyle()
    private var disposeBag = DisposeBag()
    
    private var moreButtonTabbed = true
    private var myInfo: UserInfo?
    
    //tableview에서 선택된 값
    private var myGender = -1
    private var myHobby = ""
    private var myNumberSearch = 0
    private var myPreferredAge = [18, 35]
    private var myCharacter = 0
    private var myBackground = 0
    
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
    
    private func getUserInfo() {
        print(#function)
        
        self.viewModel.getUser() { apiResult, getUserResult, userInfo in
            if let getUserResult = getUserResult {
                switch getUserResult {
                case .existingUser:
                    DispatchQueue.main.async {
                        if let userInfo = userInfo {
                            print(userInfo)
                            UserDefaults.standard.set(userInfo.background, forKey: UserdefaultKey.shopBackground.rawValue)
                            UserDefaults.standard.set(userInfo.sesac, forKey: UserdefaultKey.shopCharacter.rawValue)
                            UserDefaults.standard.set(userInfo.sesacCollection, forKey: UserdefaultKey.sesacCollection.rawValue)
                            UserDefaults.standard.set(userInfo.backgroundCollection, forKey: UserdefaultKey.backgroundCollection.rawValue)
                            
                            self.myInfo = userInfo
                            self.myGender = userInfo.gender
                            self.myHobby = userInfo.hobby
                            self.myNumberSearch = userInfo.searchable
                            self.myPreferredAge = [userInfo.ageMin, userInfo.ageMax]
                            self.myCharacter = userInfo.sesac
                            self.myBackground = userInfo.background
                        }
                        self.mainView.tableView.reloadData()

                    }
                case .tokenError:
                    self.getUserInfo()
                    return
                case .newUser:
                    DispatchQueue.main.async {
                        //온보딩 화면으로 이동
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: OnBoardingViewController())
                        windowScene.windows.first?.makeKeyAndVisible()
                    }
                case .serverError:
                    DispatchQueue.main.async {
                        self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: .defaultStyle)
                    }
                case .clientError:
                    DispatchQueue.main.async {
                        self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: .defaultStyle)
                    }
                }
            }
        }
    }
    

    private func userWithdrawRequest() {
        print("회원탈퇴 시작")
        //회원탈퇴 api 통신
        self.viewModel.userWithdraw { apiResult, userWithdrawResult in
            print(userWithdrawResult)
            if userWithdrawResult == .succeed || userWithdrawResult == .alreadyProcessed {
                DispatchQueue.main.async {
                    //userdefault 초기화
                    for key in UserDefaults.standard.dictionaryRepresentation().keys {
                        UserDefaults.standard.removeObject(forKey: key.description)
                    }
                    //온보딩 화면으로 이동
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: OnBoardingViewController())
                    windowScene.windows.first?.makeKeyAndVisible()
                }
            } else if userWithdrawResult == .tokenError {
                self.userWithdrawRequest()
            } else {
                //에러
                self.view.makeToast("에러가 발생했습니다! 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
            }
        }
    }
    
    private func userInfoUpdateRequest() {
        
        self.viewModel.userInfoUpdate(searchable: self.myNumberSearch, ageMin: self.myPreferredAge[0], ageMax: self.myPreferredAge[1], gender: self.myGender, hobby: self.myHobby) { apiResult, userInfoUpdateResult in
            
            if userInfoUpdateResult == .succeed {
                print("업데이트 성공")
                //userDefault에 업데이트 시켜야함!(성별,
                UserDefaults.standard.set(self.myGender, forKey: UserdefaultKey.gender.rawValue)
                
                self.getUserInfo()
            } else if userInfoUpdateResult == .tokenError {
                self.userInfoUpdateRequest()
            } else {
                self.view.makeToast("에러가 발생했습니다! 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
            }
            
        }
        
    }

        
    @objc func saveButtonClicked() {
        print(#function)
        //정보관리 뷰의 저장 버튼이 클릭 -> 각 테이블뷰 셀의 값을 서버에 업데이트 할 수 있게 해야함
        //1. 테이블뷰의 데이터 가져오기
        //2. api 통신
        
        //print("myGender: \(myGender) myHobby: \(myHobby) myNumberSearch: \(myNumberSearch) myPreferredAge: \(myPreferredAge)")
        self.userInfoUpdateRequest()
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
        
        self.viewDidLayoutSubviews()
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
            
            cell.backgroundImage.image = UIImage(named: "sesac_background_\(self.myBackground + 1)")
            cell.charactorImage.image = UIImage(named: "sesac_face_\(self.myCharacter + 1)")
            cell.matchingButton.isHidden = true
            
            return cell
            
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.CardTableViewCell.id) as? CardTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.titleCollectionView.delegate = self
            cell.titleCollectionView.dataSource = self
            cell.titleCollectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id)
            
            cell.titleCollectionView.tag = 101
            cell.hobbyCollectionView.tag = 102
            if let myInfo = self.myInfo {
                cell.nicknameLabel.text = myInfo.nick
                cell.updateCell(reputation: myInfo.reputation, review: myInfo.comment, hobby: [myInfo.hobby])
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
                    print(cell.manButton.status)
                    cell.womanButton.status = .inactive
                    self.myGender = 1
                    return .fill
                }
                .map { $0 }
                .bind(to: cell.manButton.rx.status)
                .disposed(by: cell.bag)
            
            cell.womanButton.rx.tap
                .scan(cell.womanButton.status) { lastState, newState in
                    cell.manButton.status = .inactive
                    self.myGender = 0
                    return .fill
                }
                .map { $0 }
                .bind(to: cell.womanButton.rx.status)
                .disposed(by: cell.bag)

            
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
        if indexPath.row == 6 {
            print("회원탈퇴 진행")
            
            //1. UIAlertController 생성: 밑바탕 + 타이틀 + 본문
            //let alert = UIAlertController(title: "타이틀 테스트", message: "메시지가 입력되었습니다.", preferredStyle: .alert)
            let alert = UIAlertController(title: "회원 탈퇴", message: "정말 탈퇴하시겠습니까?", preferredStyle: .alert)
            
            //2. UIAlertAction 생성: 버튼들을...
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                self.userWithdrawRequest()
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)


            //3. 1 + 2
            alert.addAction(ok)
            alert.addAction(cancel)

            //4. present
            self.present(alert, animated: true, completion: nil)

        }
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
        cell.button.isEnabled = false
        cell.button.status = .inactive
        
        if let data = self.myInfo {
            if data.reputation[indexPath.row] == 0 {
                cell.button.status = .inactive
            } else {
                cell.button.status = .fill
            }
        }
        
        return cell
    }
}

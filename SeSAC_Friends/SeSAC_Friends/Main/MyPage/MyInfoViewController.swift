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
        
        return tableView
    }()
    
    let disposeBag = DisposeBag()
    
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
        tableView.register(TwoButtonTableViewCell.self, forCellReuseIdentifier: "TwoButtonTableViewCell")
        tableView.register(TextfieldTableViewCell.self, forCellReuseIdentifier: "TextfieldTableViewCell")
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "SwitchTableViewCell")
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: "LabelTableViewCell")
        tableView.register(DoubleSliderTableViewCell.self, forCellReuseIdentifier: "DoubleSliderTableViewCell")
        
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
}

extension MyInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    //tableView Header View
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CharactorView()
        headerView.backgroundImage.image = UIImage(named: "sesac_background_1")
        headerView.charactorImage.image = UIImage(named: "sesac_face_1")
        headerView.layer.masksToBounds = true
        headerView.layer.cornerRadius = 10
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 3 {
            return 120
        } else {
            return 72
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TwoButtonTableViewCell") as? TwoButtonTableViewCell else { return UITableViewCell()}
            
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
            
        }  else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextfieldTableViewCell") as? TextfieldTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.label.text = "자주 하는 취미"
            cell.textfield.textfield.placeholder = "취미를 입력해주세요"
            
            return cell
            
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell") as? SwitchTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.label.text = "내 번호 검색 허용"
            
            return cell
            
        }  else if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleSliderTableViewCell") as? DoubleSliderTableViewCell else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.label.text = "상대방 연령대"
            cell.ageLabel.text = "18-35"
            
            cell.slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell") as? LabelTableViewCell else { return UITableViewCell()}
            
            cell.label.text = "회원탈퇴"
            
            return cell
            
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}

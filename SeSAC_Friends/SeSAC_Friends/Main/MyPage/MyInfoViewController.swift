//
//  MyInfoViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/26.
//

import UIKit

import RxCocoa
import RxSwift

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
        tableView.register(GenderSelectTableViewCell.self, forCellReuseIdentifier: "GenderSelectTableViewCell")
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
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GenderSelectTableViewCell") as? GenderSelectTableViewCell else { return UITableViewCell()}
            
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
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GenderSelectTableViewCell") as? GenderSelectTableViewCell else { return UITableViewCell()}
            
            cell.label.text = "자주 하는 취미"
            
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

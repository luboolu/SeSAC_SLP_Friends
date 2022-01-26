//
//  MyInfoViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/26.
//

import UIKit

import SnapKit

class MyInfoViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell()}
        
        let charactorView = CharactorView()
        
        charactorView.backgroundImage.image = UIImage(named: "sesac_background_1")
        charactorView.charactorImage.image = UIImage(named: "sesac_face_1")
        
        
        cell.addSubview(charactorView)
        charactorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return cell
    }
}

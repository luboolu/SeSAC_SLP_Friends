//
//  MyPageView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/27.
//

import UIKit
import SnapKit

final class MyPageView: UIView, ViewRepresentable {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func setupView() {
        self.backgroundColor = UIColor().white

        self.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

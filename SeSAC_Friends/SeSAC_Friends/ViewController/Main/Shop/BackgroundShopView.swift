//
//  BackgroundShopView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/20.
//

import UIKit

import SnapKit

final class BackgroundShopView: UIView, ViewRepresentable {
    
    let backgroundTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
         
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
        self.addSubview(backgroundTableView)
    }
    
    func setupConstraints() {
        backgroundTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16).priority(999)
            make.trailing.equalToSuperview().offset(-16).priority(999)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

//
//  ReviewDetailView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/14.
//

import UIKit

import SnapKit

final class ReviewDetailView: UIView, ViewRepresentable {
    
    let reviewTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.separatorStyle = .singleLine
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
        self.addSubview(reviewTableView)
    }
    
    func setupConstraints() {
        reviewTableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
    }
}

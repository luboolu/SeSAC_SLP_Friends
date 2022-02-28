//
//  NearSeSacView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/08.
//
import UIKit

final class NearSeSacView: UIView, ViewRepresentable {
    
    let friendsTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 2.0
         
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
        self.addSubview(friendsTableView)
    }
     
    func setupConstraints() {
        friendsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
}

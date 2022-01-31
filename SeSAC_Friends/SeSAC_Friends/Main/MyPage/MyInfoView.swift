//
//  MyInfoView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/31.
//

import UIKit

import SnapKit

class MyInfoView: UIView, ViewRepresentable {
    
    let tableView: UITableView = {
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
        self.addSubview(tableView)
        
        //custom tableview cell register
        tableView.register(TwoButtonTableViewCell.self, forCellReuseIdentifier: TableViewCell.TwoButtonTableViewCell.id)
        tableView.register(TextfieldTableViewCell.self, forCellReuseIdentifier: TableViewCell.TextfieldTableViewCell.id)
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: TableViewCell.SwitchTableViewCell.id)
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: TableViewCell.LabelTableViewCell.id)
        tableView.register(DoubleSliderTableViewCell.self, forCellReuseIdentifier: TableViewCell.DoubleSliderTableViewCell.id)
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: TableViewCell.CardTableViewCell.id)
        tableView.register(CharactorTableViewCell.self, forCellReuseIdentifier: TableViewCell.CharactorTableViewCell.id)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

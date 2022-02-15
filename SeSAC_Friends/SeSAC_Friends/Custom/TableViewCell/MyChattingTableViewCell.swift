//
//  MyChattingTableViewCell.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/15.
//
import UIKit

import SnapKit

final class MyChattingTableViewCell: UITableViewCell, ViewRepresentable {
    
    let chatView = UIView()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont().Title6_R12
        label.textColor = UIColor().gray6
        label.textAlignment = .center
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func setupView() {
        chatView.clipsToBounds = true
        chatView.layer.cornerRadius = 8
        chatView.layer.borderWidth = 1
        chatView.layer.borderColor = UIColor().gray4.cgColor
        
        self.addSubview(chatView)
        self.addSubview(timeLabel)
    }
    
    func setupConstraints() {
        chatView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(100)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(chatView.snp.trailing).offset(8)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(40)
            make.height.equalTo(18)
        }

    }
    
}

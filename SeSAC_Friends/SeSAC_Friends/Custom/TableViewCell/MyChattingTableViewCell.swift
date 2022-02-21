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
    
    let chatTextView: UITextView = {
        let textView = UITextView()
        
        textView.font = UIFont().Body3_R14
        textView.textColor = UIColor().black
        textView.backgroundColor = UIColor().whitegreen
        textView.isScrollEnabled = false
        
        return textView
    }()
    
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
        chatView.backgroundColor = UIColor().whitegreen
        chatView.addSubview(chatTextView)
        self.addSubview(chatView)
        self.addSubview(timeLabel)
    }
    
    func setupConstraints() {
        chatView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.7)
        }
        
        chatTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(chatView.snp.leading).offset(-8)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(40)
            make.height.equalTo(18)
        }

    }
    
}

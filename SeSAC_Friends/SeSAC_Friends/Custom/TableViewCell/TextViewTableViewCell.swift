//
//  TextViewTableViewCell.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/14.
//
import UIKit

import SnapKit

final class TextViewTableViewCell: UITableViewCell, ViewRepresentable {
    
    let textView: UITextView = {
        let textView = UITextView()
        
        textView.isScrollEnabled = false
        textView.font = UIFont().Body3_R14
        textView.textColor = UIColor().black
        
        return textView
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
        self.addSubview(textView)
    }
    
    func setupConstraints() {
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    
}

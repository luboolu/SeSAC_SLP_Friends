//
//  SwitchTableViewCell.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/27.
//

import UIKit

import SnapKit

final class SwitchTableViewCell: UITableViewCell, ViewRepresentable {
    
    let label: UILabel = {
        let label = UILabel()
        
        label.font = UIFont().Title4_R14
        label.textColor = UIColor().black
        
        return label
    }()
    
    let switchButton: UISwitch = {
        let switchButton = UISwitch()
        
        switchButton.onTintColor = UIColor().green
        
        return switchButton
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
        self.addSubview(label)
        contentView.addSubview(switchButton)
    }
    
    func setupConstraints() {
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
        }
        
        switchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(label.snp.trailing).offset(14)
            make.trailing.equalToSuperview().offset(-14)
        }
    }
    
    
}

//
//  GenderSelectTableViewCell.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/27.
//

import UIKit

final class TwoButtonTableViewCell: UITableViewCell, ViewRepresentable {

    let label: UILabel = {
        let label = UILabel()
        
        label.font = UIFont().Title4_R14
        label.textColor = UIColor().black
        
        return label
    }()
    
    let manButton = MainButton(status: .inactive)
    
    let womanButton = MainButton(status: .inactive)

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
        
        manButton.setTitle("남자", for: .normal)
        manButton.titleLabel?.font = UIFont().Body4_R12
        contentView.addSubview(manButton)
        
        womanButton.setTitle("여자", for: .normal)
        womanButton.titleLabel?.font = UIFont().Body4_R12
        contentView.addSubview(womanButton)
    }
    
    func setupConstraints() {
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
        }
        
        manButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.leading.equalTo(label.snp.trailing).offset(15)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(56)
            make.height.equalTo(48)
        }
        
        womanButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.leading.equalTo(manButton.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(56)
            make.height.equalTo(48)
        }

    }
}

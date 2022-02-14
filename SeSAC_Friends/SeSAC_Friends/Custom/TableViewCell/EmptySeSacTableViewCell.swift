//
//  EmptySeSacTableViewCell.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/15.
//
import UIKit

import SnapKit

final class EmptySeSacTableViewCell: UITableViewCell, ViewRepresentable {
    
    let emptyView = UIView()
    
    let sacImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "sesac_black")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let mainTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "아쉽게도 주변에 새싹이 없어요"
        label.font = UIFont().Display1_R20
        label.textColor = UIColor().black
        
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "취미를 변경하거나 조금만 더 기다려 주세요!"
        label.font = UIFont().Title4_R14
        label.textColor = UIColor().gray7
        
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
        emptyView.addSubview(sacImageView)
        emptyView.addSubview(mainTitleLabel)
        emptyView.addSubview(subTitleLabel)
        
        self.addSubview(emptyView)
    }
    
    func setupConstraints() {
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        sacImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(mainTitleLabel.snp.top).offset(-45)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(8)
        }
    }
    
    
}

//
//  ProfileMenuView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/26.
//

import UIKit

import SnapKit

final class ProfileTableViewCell: UITableViewCell {
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "sesac_color")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 0.5 * 50
        imageView.layer.borderColor = UIColor().gray3.cgColor
        imageView.layer.borderWidth = 2
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont().Title1_M16
        label.textColor = UIColor().black
        
        return label
    }()
    
    let detailButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "more_arrow"), for: .normal)
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func setUp() {
        contentView.addSubview(profileImage)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(detailButton)
        
        detailButton.layer.zPosition = 999
    }
    
    func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(50)
            make.height.equalTo(profileImage.snp.width).multipliedBy(1)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(13)
            //make.height.equalTo(50)
        }
        
        detailButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(13)
            make.trailing.equalToSuperview().offset(-15)
            make.width.equalTo(15)
        }
    }
}

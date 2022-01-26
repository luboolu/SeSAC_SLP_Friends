//
//  ProfileMenuView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/26.
//

import UIKit

import SnapKit

class ProfileMenuView: UIView {
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "sesac_color")
        imageView.layer.borderColor = UIColor().gray1.cgColor
        imageView.layer.borderWidth = 1
        
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        self.addSubview(profileImage)
        self.addSubview(nicknameLabel)
        self.addSubview(detailButton)
    }
    
    func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(profileImage.snp.width).multipliedBy(1)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(13)
            make.height.equalTo(50)
        }
        
        detailButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(13)
            make.trailing.equalToSuperview()
            make.width.equalTo(15)
        }
    }
}

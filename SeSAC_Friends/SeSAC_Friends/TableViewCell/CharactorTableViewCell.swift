//
//  CharactorView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/27.
//

import UIKit

import SnapKit

class CharactorTableViewCell: UITableViewCell{
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleToFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 20
        
        return imageView
    }()
    
    let charactorImage: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func setupView() {
        
        self.addSubview(backgroundImage)
        self.addSubview(charactorImage)
    }
    
    func setupConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview()
        }
        
        charactorImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(charactorImage.snp.height).multipliedBy(1)
        }
        
    }
    
}

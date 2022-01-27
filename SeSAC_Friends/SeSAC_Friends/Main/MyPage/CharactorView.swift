//
//  CharactorView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/27.
//

import UIKit

import SnapKit

class CharactorView: UIView {
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 20
        
        return imageView
    }()
    
    let charactorImage: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func setUp() {
        
        self.addSubview(backgroundImage)
        self.addSubview(charactorImage)
    }
    
    func setConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        charactorImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(charactorImage.snp.height).multipliedBy(1)
        }
        
    }
    
}

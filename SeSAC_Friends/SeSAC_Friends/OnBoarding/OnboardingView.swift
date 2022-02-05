//
//  OnboardingView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/25.
//

import UIKit

import SnapKit

final class OnboardingView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont().Display2_R24
        label.textColor = UIColor().black
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        
        image.contentMode = .scaleAspectFit
        
        return image
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
        self.backgroundColor = UIColor().white
        self.addSubview(titleLabel)
        self.addSubview(imageView)
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(140)
            make.centerX.equalToSuperview()
            make.height.equalTo(76)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(56)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}

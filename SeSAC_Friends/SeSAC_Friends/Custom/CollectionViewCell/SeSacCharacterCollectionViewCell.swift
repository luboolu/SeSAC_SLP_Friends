//
//  sesacCharacterCollectionViewCell.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/20.
//

import UIKit

import SnapKit
import RxSwift

final class SeSacCharacterCollectionViewCell: UICollectionViewCell, ViewRepresentable {
    
    let characterImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "sesac_face_1")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor().gray2.cgColor
        
        return imageView
    }()
    
    let characterName: UILabel = {
        let label = UILabel()
        
        label.text = "기본 새싹"
        label.textColor = UIColor().black
        label.font = UIFont().Title2_R16
        label.textAlignment = .left
        
        return label
    }()
    
    let priceButton: MainButton = {
        let button = MainButton()
        
        button.isBorder = false
        button.isRounded = true
        button.status = .fill
        button.titleLabel?.font = UIFont().Title5_M12
        
        return button
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다."
        label.textColor = UIColor().black
        label.font = UIFont().Body3_R14
        label.numberOfLines = 0
        
        return label
    }()
    
    var bag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func setupView() {
        contentView.addSubview(characterImage)
        contentView.addSubview(characterName)
        contentView.addSubview(priceButton)
        contentView.addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        characterImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(characterImage.snp.height).multipliedBy(1)
        }
        
        characterName.snp.makeConstraints { make in
            make.top.equalTo(characterImage.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            //make.height.equalTo(24)
            
        }
        
        priceButton.snp.makeConstraints { make in
            make.top.equalTo(characterImage.snp.bottom).offset(8)
            make.leading.equalTo(characterName.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(characterName)
            make.width.equalTo(52)
            make.height.equalTo(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(characterName.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        super.preferredLayoutAttributesFitting(layoutAttributes)
//        layoutIfNeeded()
//
//        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//        var frame = layoutAttributes.frame
//
//        frame.size.height = ceil(size.height)
//
//        layoutAttributes.frame = frame
//
//        return layoutAttributes
//    }

}

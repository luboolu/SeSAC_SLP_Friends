//
//  SeSacBackgroundTableViewCell.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/20.
//
import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class SeSacBackgroundTableViewCell: UITableViewCell, ViewRepresentable {
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "sesac_background_1")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        
        return imageView
    }()
    
    let descriptionView = UIView()
    
    let backgroundName: UILabel = {
        let label = UILabel()
        
        label.text = "하늘 공원"
        label.textColor = UIColor().black
        label.font = UIFont().Title3_M14
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
        
        label.text = "새싹들을 많이 마주치는 매력적인 하늘 공원입니다."
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func setupView() {
        contentView.addSubview(backgroundImage)
        
        descriptionView.addSubview(backgroundName)
        descriptionView.addSubview(priceButton)
        descriptionView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionView)
    }
    
    func setupConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
            make.height.equalTo(backgroundImage.snp.width).multipliedBy(1)
            make.width.equalTo(165)
        }
        
        descriptionView.snp.makeConstraints { make in
            make.centerY.equalTo(backgroundImage)
            make.leading.equalTo(backgroundImage.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
        }
        
        backgroundName.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        priceButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)
            make.width.equalTo(52)
            make.centerY.equalTo(backgroundName)
            make.height.equalTo(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundName.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    
}

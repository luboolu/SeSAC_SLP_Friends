//
//  CharactorView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/27.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class CharactorTableViewCell: UITableViewCell{
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        
        return imageView
    }()
    
    let charactorImage: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    let matchingButton: SubButton = {
        let button = SubButton()
        
        button.status = .request
        button.layer.zPosition = 999
        
        return button
    }()
    
    var bag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
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
        
        contentView.addSubview(backgroundImage)
        contentView.addSubview(charactorImage)
        contentView.addSubview(matchingButton)
    }
    
    func setupConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(0)
        }
        
        charactorImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(charactorImage.snp.height).multipliedBy(1)
        }
        
        matchingButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16 + 12)
            make.trailing.equalToSuperview().offset(-16 - 12)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        
    }
    
}

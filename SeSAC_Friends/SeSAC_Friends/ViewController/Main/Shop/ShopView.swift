//
//  ShopView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/20.
//

import UIKit

import SnapKit

final class ShopView: UIView, ViewRepresentable {
    
    let charactorView = UIView()
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.image = UIImage(named: "sesac_background_1")
        
        return imageView
    }()
    
    let charactorImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "sesac_face_1")
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    let saveButton: MainButton = {
        let button = MainButton()
        
        button.isBorder = true
        button.isRounded = true
        button.status = .fill
        button.setTitle("저장하기", for: .normal)
        button.titleLabel?.font = UIFont().Body3_R14
        
        return button
    }()
    
    //tap 이동 관련
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }()
    
    let character = UIView()
    
    let characterViewButton: MainButton = {
        let button = MainButton()
        
        button.status = .outline
        button.isRounded = false
        button.isBorder = false
        button.setTitle("새싹", for: .normal)
        button.titleLabel?.font = UIFont().Title3_M14
        
        return button
    }()
    
    let characterViewButtonLine: MainButton = {
        let button = MainButton()
        
        button.status = .fill
        button.isRounded = false
        button.isBorder = false
        button.setTitle("", for: .normal)
        
        return button
    }()
    
    let background = UIView()
    
    let backgroundViewButton: MainButton = {
        let button = MainButton()
        
        button.status = .inactive
        button.isRounded = false
        button.isBorder = false
        button.setTitle("배경", for: .normal)
        button.titleLabel?.font = UIFont().Title3_M14
        
        return button
    }()
    
    let backgroundViewButtonLine: MainButton = {
        let button = MainButton()
        
        button.status = .inactive
        button.isRounded = false
        button.isBorder = false
        button.setTitle("", for: .normal)
        
        return button
    }()
    
    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    
    func setupView() {
        self.backgroundColor = UIColor().white
        
        charactorView.addSubview(backgroundImage)
        charactorView.addSubview(charactorImage)
        charactorView.addSubview(saveButton)
        
        self.addSubview(charactorView)
        
        character.addSubview(characterViewButton)
        character.addSubview(characterViewButtonLine)
        background.addSubview(backgroundViewButton)
        background.addSubview(backgroundViewButtonLine)
        
        buttonStackView.addArrangedSubview(character)
        buttonStackView.addArrangedSubview(background)
        
        self.addSubview(buttonStackView)
        //contentView.backgroundColor = UIColor().error
        self.addSubview(contentView)
    }
    
    func setupConstraints() {
        charactorView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(50)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(174)
        }
        
        backgroundImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
        
        charactorImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(charactorImage.snp.height).multipliedBy(1)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-28)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(charactorView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
        
        character.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        characterViewButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        characterViewButtonLine.snp.makeConstraints { make in
            make.top.equalTo(characterViewButton.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        background.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        backgroundViewButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        backgroundViewButtonLine.snp.makeConstraints { make in
            make.top.equalTo(backgroundViewButton.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    
}

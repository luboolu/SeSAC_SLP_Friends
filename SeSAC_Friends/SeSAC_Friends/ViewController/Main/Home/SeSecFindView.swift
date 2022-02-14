//
//  SeSecFindView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/08.
//

import UIKit

import SnapKit

final class SeSacFindView: UIView, ViewRepresentable {
    
    let buttonView = UIView()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }()
    
    let near = UIView()
    
    let nearViewButton: MainButton = {
        let button = MainButton()
        
        button.status = .outline
        button.isRounded = false
        button.isBorder = false
        button.setTitle("주변 새싹", for: .normal)
        button.titleLabel?.font = UIFont().Title3_M14
        
        return button
    }()
    
    let nearViewLine: MainButton = {
        let button = MainButton()
        
        button.status = .fill
        button.isRounded = false
        button.isBorder = false
        button.setTitle("", for: .normal)
        
        return button
    }()
    
    let recived = UIView()
    
    let recivedViewButton: MainButton = {
        let button = MainButton()
        
        button.status = .inactive
        button.isRounded = false
        button.isBorder = false
        button.setTitle("받은 요청", for: .normal)
        button.titleLabel?.font = UIFont().Title3_M14
        
        return button
    }()
    
    let recivedViewLine: MainButton = {
        let button = MainButton()
        
        button.status = .inactive
        button.isRounded = false
        button.isBorder = false
        button.setTitle("", for: .normal)
        
        return button
    }()
    
    let contentView = UIView()
    
    let hobbyChangeButton: MainButton = {
        let button = MainButton()
        
        button.status = .fill
        button.isBorder = false
        button.isRounded = true
        button.setTitle("취미 변경하기", for: .normal)
        button.titleLabel?.font = UIFont().Body3_R14
        
        return button
    }()
    
    let resetButton: MainButton = {
        let button = MainButton()
        
        button.status = .outline
        button.isBorder = true
        button.isRounded = true
        button.imageStyle = .reset_color
        button.setTitle("", for: .normal)
        
        return button
    }()
    
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
        //buttonStackView.backgroundColor = UIColor().error
        //near.backgroundColor = UIColor().green
        near.addSubview(nearViewButton)
        near.addSubview(nearViewLine)
        
        buttonStackView.addArrangedSubview(near)
        
        recived.addSubview(recivedViewButton)
        recived.addSubview(recivedViewLine)
        
        buttonStackView.addArrangedSubview(recived)
        
        self.addSubview(buttonStackView)
        contentView.backgroundColor = UIColor().error
        self.addSubview(contentView)
        
        self.addSubview(hobbyChangeButton)
        self.addSubview(resetButton)
    }
    
    func setupConstraints() {
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
        
        near.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        nearViewButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        nearViewLine.snp.makeConstraints { make in
            make.top.equalTo(nearViewButton.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        recived.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        recivedViewButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        recivedViewLine.snp.makeConstraints { make in
            make.top.equalTo(recivedViewButton.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        hobbyChangeButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(resetButton.snp.leading).offset(-8)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-30)
            make.height.equalTo(48)
        }
        
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-30)
            make.width.equalTo(48)
            make.height.equalTo(48)
        }

        
    }
    
}

//
//  HomeViewswift.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/03.
//

import UIKit

import SnapKit

final class HomeView: UIView, ViewRepresentable {
    
    let genderStackView: UIStackView = {
        let stackview = UIStackView()
        
        stackview.axis = .vertical
        stackview.spacing = 0
        stackview.distribution = .fillEqually
        stackview.alignment = .center
        stackview.clipsToBounds = true
        stackview.layer.cornerRadius = 8
        
        return stackview
    }()
    
    let genderButton1: UIButton = {
        let button = UIButton()
        
        button.setTitle("전체", for: .normal)
        button.backgroundColor = UIColor().green
        button.setTitleColor(UIColor().black, for: .normal)
        button.titleLabel?.font = UIFont().Title3_M14
        
        return button
    }()
    
    let genderButton2: UIButton = {
        let button = UIButton()
        
        button.setTitle("남자", for: .normal)
        button.setTitleColor(UIColor().black, for: .normal)
        button.backgroundColor = UIColor().white
        button.tintColor = UIColor().black
        button.titleLabel?.font = UIFont().Title3_M14
        
        return button
    }()
    
    let genderButton3: UIButton = {
        let button = UIButton()
        
        button.setTitle("여자", for: .normal)
        button.setTitleColor(UIColor().black, for: .normal)
        button.backgroundColor = UIColor().green
        button.tintColor = UIColor().black
        button.titleLabel?.font = UIFont().Title3_M14
        
        return button
    }()
    
    let locationButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor().white
        button.setImage(UIImage(named: "place"), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "default_button"), for: .normal)
        
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
        self.backgroundColor = UIColor().gray4
        self.addSubview(searchButton)
        
        genderStackView.addArrangedSubview(genderButton1)
        genderStackView.addArrangedSubview(genderButton2)
        genderStackView.addArrangedSubview(genderButton3)
        
        self.addSubview(genderStackView)
        self.addSubview(locationButton)
    }
    
    func setupConstraints() {
        searchButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(64)
            make.height.equalTo(searchButton.snp.width).multipliedBy(1)
        }
        
        genderStackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(48)
            make.height.equalTo(144)
        }
        
        genderButton1.snp.makeConstraints { make in
            make.width.equalTo(genderButton1.snp.height).multipliedBy(1)
        }

        genderButton2.snp.makeConstraints { make in
            make.width.equalTo(genderButton2.snp.height).multipliedBy(1)
        }

        genderButton3.snp.makeConstraints { make in
            make.width.equalTo(genderButton3.snp.height).multipliedBy(1)
        }
        
        locationButton.snp.makeConstraints { make in
            make.top.equalTo(genderStackView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
    }
    
    
}

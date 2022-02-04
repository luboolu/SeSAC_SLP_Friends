//
//  HomeViewswift.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/03.
//

import UIKit

import SnapKit

final class HomeView: UIView, ViewRepresentable {
    
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
        self.addSubview(searchButton)
    }
    
    func setupConstraints() {
        searchButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(64)
            make.height.equalTo(searchButton.snp.width).multipliedBy(1)
        }
    }
    
    
}

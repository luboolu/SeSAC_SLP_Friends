//
//  ChattingMenuView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/15.
//

import UIKit

import SnapKit

final class ChattingMenuView: UIView, ViewRepresentable {
    
    let menuStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.backgroundColor = UIColor().error
        
        return stackView
    }()
    
    let reportButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "siren"), for: .normal)
        
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "siren"), for: .normal)
        
        return button
    }()
    
    let reviewButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "write"), for: .normal)
        
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
        self.backgroundColor = UIColor.clear
        
        menuStackView.addArrangedSubview(reportButton)
        menuStackView.addArrangedSubview(cancelButton)
        menuStackView.addArrangedSubview(reviewButton)
        self.addSubview(menuStackView)
    }
    
    func setupConstraints() {
        menuStackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(72)
        }
    }
}

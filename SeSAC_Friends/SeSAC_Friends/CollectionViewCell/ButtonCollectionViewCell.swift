//
//  ButtonCollectionViewCell.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/29.
//

import UIKit

import SnapKit

class ButtonCollectionViewCell: UICollectionViewCell, ViewRepresentable {
    
    
    let button = MainButton(status: .inactive)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func setupView() {
        contentView.addSubview(button)
    }
    
    func setupConstraints() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

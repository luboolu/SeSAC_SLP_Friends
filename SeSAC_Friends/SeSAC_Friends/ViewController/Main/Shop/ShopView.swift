//
//  ShopView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/20.
//

import UIKit

import SnapKit

final class ShopView: UIView, ViewRepresentable {
    
    
    
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

    }
    
    func setupConstraints() {

    }
    
    
}

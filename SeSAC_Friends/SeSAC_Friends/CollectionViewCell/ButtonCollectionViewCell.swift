//
//  ButtonCollectionViewCell.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/29.
//

import UIKit

import SnapKit
import RxSwift

final class ButtonCollectionViewCell: UICollectionViewCell, ViewRepresentable {
    
    let button: MainButton = {
        let button = MainButton(status: .inactive)
        
        button.titleLabel?.font = UIFont().Title4_R14
        
        return button
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
        contentView.addSubview(button)
    }
    
    func setupConstraints() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()

        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame

        frame.size.height = ceil(size.height)

        layoutAttributes.frame = frame

        return layoutAttributes
    }

}

//
//  CardTableViewCell.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/27.
//

import UIKit

import SnapKit

class CardTableViewCell: UITableViewCell, ViewRepresentable {
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont().Title1_M16
        label.textColor = UIColor().black
        
        return label
    }()
    
    let moreButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "more_arrow_down"), for: .normal)
        
        return button
    }()
    
    let firstStackView: UIStackView = {
        let stackview = UIStackView()
        
        stackview.axis = .horizontal
        stackview.spacing = 10
        stackview.distribution = .fill
        stackview.alignment = .center
        
        return stackview
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func setupView() {
        
        firstStackView.clipsToBounds = true
        firstStackView.layer.cornerRadius = 5
        firstStackView.layer.borderColor = UIColor().gray2.cgColor
        firstStackView.layer.borderWidth = 2

        firstStackView.addArrangedSubview(nicknameLabel)
        firstStackView.addArrangedSubview(moreButton)
        
        contentView.addSubview(firstStackView)
        
    }
    
    func setupConstraints() {
        
        firstStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
            make.bottom.equalToSuperview().offset(-14)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
        }
        
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-14)
            make.width.equalTo(20)
        }
        
    }
}

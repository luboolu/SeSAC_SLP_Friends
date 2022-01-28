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
    
    let secondStackView: UIStackView = {
        let stackview = UIStackView()
        
        stackview.axis = .vertical
        stackview.spacing = 0
        stackview.distribution = .equalSpacing
        stackview.alignment = .center
        
        return stackview
    }()
    
    let testButton = MainButton(status: .fill)
    
    
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
        
        secondStackView.addArrangedSubview(firstStackView)
        secondStackView.addArrangedSubview(testButton)
        
        contentView.addSubview(secondStackView)
        
    }
    
    func setupConstraints() {
        
        firstStackView.snp.makeConstraints { make in
            //make.top.equalTo(secondStackView.snp.top)
            make.leading.equalTo(secondStackView.snp.leading)
            make.trailing.equalTo(secondStackView.snp.trailing)
            make.height.equalTo(58)
        }
        
        secondStackView.snp.makeConstraints { make in
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
        
        testButton.snp.makeConstraints { make in
//            make.top.equalTo(firstStackView.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
//            make.bottom.equalTo(secondStackView.snp.bottom)
            make.height.equalTo(30)
            //make.width.equalToSuperview()
        }
        
    }
}

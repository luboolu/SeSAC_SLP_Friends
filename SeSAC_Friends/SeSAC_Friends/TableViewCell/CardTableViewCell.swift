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
    
    let representView = UIView()
    
    let cardStackView: UIStackView = {
        let stackview = UIStackView()
        
        stackview.axis = .vertical
        stackview.spacing = 10
        stackview.distribution = .fill
        stackview.alignment = .center
        
        return stackview
    }()
    
    let titleCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        
        return collectionView
    }()
    
    let testButton = MainButton(status: .fill)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
        
        print("titlecollectionview width: \(titleCollectionView.frame.width)")
        //print("width: \(width)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func setupView() {
        representView.clipsToBounds = true
        representView.layer.cornerRadius = 5
        representView.layer.borderColor = UIColor().gray2.cgColor
        representView.layer.borderWidth = 1
        
        representView.addSubview(nicknameLabel)
        representView.addSubview(moreButton)
        
        cardStackView.addArrangedSubview(representView)
        cardStackView.addArrangedSubview(testButton)
        
        //collection view flow layout 설정
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = (UIScreen.main.bounds.width - (spacing * 3) - 28) / 2
        let height: CGFloat = 32
        
        print("titlecollectionview width: \(UIScreen.main.bounds.width)")
        print("width: \(width)")

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical

        titleCollectionView.collectionViewLayout = layout
        titleCollectionView.isPagingEnabled = false
        titleCollectionView.backgroundColor = UIColor().white
        
        cardStackView.addArrangedSubview(titleCollectionView)
        contentView.addSubview(cardStackView)
    }
    
    func setupConstraints() {
        cardStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        representView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
            make.height.equalTo(58)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(14)
            make.trailing.equalToSuperview().offset(-14)
        }
        
        testButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
            make.height.equalTo(30)
        }
        
        titleCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
            make.height.equalTo(32 * 3 + 8 * 3)
        }
    }

}

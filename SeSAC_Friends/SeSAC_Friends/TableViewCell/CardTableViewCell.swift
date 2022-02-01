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
        
        label.text = "   "
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
        stackview.spacing = 0
        stackview.distribution = .fill
        stackview.alignment = .center
        
        return stackview
    }()
    
    let titleView = UIView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "새싹 타이틀"
        label.textColor = UIColor().black
        label.font = UIFont().Title6_R12
        
        return label
    }()
    
    let titleCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        
        //collection view flow layout 설정
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = (UIScreen.main.bounds.width - (spacing * 3) - 28) / 2
        let height: CGFloat = 32

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical

        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        
        return collectionView
    }()
    
    let hobbyView = UIView()
    
    let hobbyLabel: UILabel = {
        let label = UILabel()
        
        label.text = "하고 싶은 취미"
        label.textColor = UIColor().black
        label.font = UIFont().Title6_R12
        label.backgroundColor = UIColor().error
        
        return label
    }()
    
    let hobbyCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        
        //collection view flow layout 설정
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = (UIScreen.main.bounds.width - (spacing * 3) - 28) / 2
        let height: CGFloat = 32

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical

        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = UIColor().whitegreen
        
        return collectionView
    }()
    
    let reviewView = UIView()
    
    let reviewLabel: UILabel = {
        let label = UILabel()
        
        label.text = "새싹 리뷰"
        label.textColor = UIColor().black
        label.font = UIFont().Title6_R12
        
        return label
    }()
    
    let reviewTextView: UITextView = {
        let textview = UITextView()
        
        textview.text = "첫 리뷰를 기다리는 중이에요!"
        textview.textColor = UIColor().gray6
        textview.font = UIFont().Body3_R14
        textview.isScrollEnabled = false
        textview.isEditable = false
        
        return textview
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func setupView() {
        cardStackView.clipsToBounds = true
        cardStackView.layer.cornerRadius = 5
        cardStackView.layer.borderColor = UIColor().gray2.cgColor
        cardStackView.layer.borderWidth = 1
        
        representView.addSubview(nicknameLabel)
        representView.addSubview(moreButton)
        cardStackView.addArrangedSubview(representView)
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(titleCollectionView)
        cardStackView.addArrangedSubview(titleView)
        
        hobbyView.addSubview(hobbyLabel)
        hobbyView.addSubview(hobbyCollectionView)
        cardStackView.addArrangedSubview(hobbyView)
        
        reviewView.addSubview(reviewLabel)
        reviewView.addSubview(reviewTextView)
        cardStackView.addArrangedSubview(reviewView)
        
        contentView.addSubview(cardStackView)
        
        //처음엔 cardview가 접혀있어야함
        
    }
    
    func setupConstraints() {
        cardStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
            make.bottom.equalToSuperview().offset(-14)
        }
        
        representView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
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
        
        titleView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalTo(titleCollectionView.snp.top).offset(-14)
        }

        titleCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
            make.bottom.equalTo(hobbyView.snp.top)
            make.height.equalTo(32 * 3 + 8 * 3)
        }

        hobbyView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        hobbyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalTo(hobbyCollectionView.snp.top).offset(-14)
        }
        
        hobbyCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
            make.bottom.equalToSuperview()
            make.height.equalTo(32 * 3 + 8 * 3)
        }
        
        reviewView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalTo(reviewTextView.snp.top).offset(-14)
        }
        
        reviewTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview()
        }
    }
    
//    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
//        <#code#>
//    }

}

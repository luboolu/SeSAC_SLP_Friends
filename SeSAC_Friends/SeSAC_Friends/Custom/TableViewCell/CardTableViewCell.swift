//
//  CardTableViewCell.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/27.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class CardTableViewCell: UITableViewCell, ViewRepresentable {
    
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
        //label.backgroundColor = UIColor().error
        
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
        //collectionView.backgroundColor = UIColor().whitegreen
        
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
    
    var userHobbyData: [String] = ["밥", "냠냠"]
    var userData: FromQueueDB?
    
    //cardview에 보여줄 유저 정보
    var userReputation: [Int]?
    var userHobby: [String]?
    var userReview: [String]?
    
    var bag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
        setupConstraints()
        
        titleCollectionView.delegate = self
        titleCollectionView.dataSource = self
        titleCollectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id)
        
        
        hobbyCollectionView.delegate = self
        hobbyCollectionView.dataSource = self
        hobbyCollectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id)
        hobbyCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        
        setHobbyCollectionViewLayout()
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
            make.bottom.equalTo(hobbyCollectionView.snp.top).offset(0)
        }
        
        hobbyCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
            make.bottom.equalToSuperview()
            make.height.equalTo(48)
        }
        
        reviewView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            //make.bottom.equalTo(reviewTextView.snp.top).offset(-14)
        }
        
        reviewTextView.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-14)
        }
    }
    
    func setHobbyCollectionViewLayout() {
        
        if let flowLayout = hobbyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
          }

        let height = hobbyCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        hobbyCollectionView.snp.removeConstraints()
        hobbyCollectionView.snp.remakeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(height + 32)
        }
        
        self.layoutIfNeeded()
    }

}

extension CardTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func updateCell(reputation: [Int], review: [String], hobby: [String]) {
        self.userReputation = reputation
        self.userReview = review
        self.userHobby = hobby
        
        if review.count > 0 {
            self.reviewTextView.text = "\(review[0])"
        }
        
        self.titleCollectionView.reloadData()
        self.hobbyCollectionView.reloadData()
        self.reviewView.reloadInputViews()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 101 {
            return 6
        } else {
            return self.userHobby?.count ?? 0
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 101 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id, for: indexPath) as? ButtonCollectionViewCell else { return UICollectionViewCell() }
            
            let titleList = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 취미 실력", "유익한 시간"]
            
            cell.button.setTitle("\(titleList[indexPath.row])", for: .normal)
            cell.button.isEnabled = false

            if self.userReputation?[indexPath.row] ?? 0 > 0 {
                cell.button.status = .fill
            } else {
                cell.button.status = .inactive
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.ButtonCollectionViewCell.id, for: indexPath) as? ButtonCollectionViewCell else { return UICollectionViewCell() }
            
            cell.button.setTitle("\(self.userHobby?[indexPath.row] ?? "")", for: .normal)
            cell.button.isEnabled = false
            cell.button.status = .inactive
            
            let height = collectionView.collectionViewLayout.collectionViewContentSize.height
            
            collectionView.snp.removeConstraints()
            collectionView.snp.remakeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(height + 16)
            }
            
            return cell
        }

    }
}

extension CardTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 101 {
            return CGSize(width: Int((collectionView.frame.width - 40 ) / 2), height: 32)
        } else {
            let button = UIButton(frame: CGRect.zero)
            button.setTitle("\(self.userHobby?[indexPath.row] ?? "")", for: .normal)
            button.sizeToFit()
            
            return CGSize(width: button.frame.width + 10, height: 32)
        }
    }
}

//
//  HobbySearchView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/03.
//

import UIKit

import SnapKit

class HobbySearchView: UIView, ViewRepresentable {
    
    let nearLabel: UILabel = {
        let label = UILabel()
        
        label.text = "지금 주변에는"
        label.font = UIFont().Title6_R12
        label.textColor = UIColor().black
        
        return label
    }()
    
    let nearCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        
        collectionView.backgroundColor = UIColor().whitegreen
        
        return collectionView
    }()
    
    let myLabel: UILabel = {
        let label = UILabel()
        
        label.text = "내가 하고 싶은"
        label.font = UIFont().Title6_R12
        label.textColor = UIColor().black
        
        return label
    }()
    
    let myCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        
        collectionView.backgroundColor = UIColor().whitegreen
        
        return collectionView
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
        self.backgroundColor = UIColor().white
        
        self.addSubview(nearLabel)
        self.addSubview(nearCollectionView)
        
        self.addSubview(myLabel)
        self.addSubview(myCollectionView)

    }
    
    func setupConstraints() {
        nearLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        nearCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nearLabel.snp.bottom)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(200)
        }
        
        myLabel.snp.makeConstraints { make in
            make.top.equalTo(nearCollectionView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        myCollectionView.snp.makeConstraints { make in
            make.top.equalTo(myLabel.snp.bottom)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(200)
        }
    }
    
    
}

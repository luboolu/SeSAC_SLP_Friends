//
//  HobbySearchView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/03.
//

import UIKit

import SnapKit

final class HobbySearchView: UIView, ViewRepresentable {
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        
        return searchBar
    }()
    
    let nearLabel: UILabel = {
        let label = UILabel()
        
        label.text = "지금 주변에는"
        label.font = UIFont().Title6_R12
        label.textColor = UIColor().black
        
        return label
    }()
    
    let nearCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        
        collectionView.isScrollEnabled = true
        
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
        
        collectionView.isScrollEnabled = true
        
        return collectionView
    }()

    let findButton: MainButton = {
        let button = MainButton()
        
        button.status = .fill
        button.isBorder = false
        button.isRounded = true
        button.setTitle("새싹 찾기", for: .normal)
        button.titleLabel?.font = UIFont().Body3_R14
        
        return button
    }()
    
    let accFindButton: MainButton = {
        let button = MainButton()
        
        button.status = .fill
        button.isBorder = false
        button.isRounded = false
        button.setTitle("새싹 찾기", for: .normal)
        button.titleLabel?.font = UIFont().Body3_R14
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setAccView()
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
        
        self.addSubview(findButton)
    }
    
    func setupConstraints() {
        nearLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        nearCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nearLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        myLabel.snp.makeConstraints { make in
            make.top.equalTo(nearCollectionView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        myCollectionView.snp.makeConstraints { make in
            make.top.equalTo(myLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        findButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }
    
    private func setAccView() {
        //키보드가 올라왔을때 보여지는 악세서리 뷰를 정의
        let ViewForDoneButtonOnKeyboard = UIToolbar()
        ViewForDoneButtonOnKeyboard.sizeToFit()
        
        let flexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

        accFindButton.frame = CGRect.init(x: 0, y: 0, width:UIScreen.main.bounds.width, height: 48)
        let barButton = UIBarButtonItem.init(customView: accFindButton)
        ViewForDoneButtonOnKeyboard.items = [flexSpace, barButton, flexSpace]
        
        searchBar.inputAccessoryView = ViewForDoneButtonOnKeyboard
    }
    
    
}

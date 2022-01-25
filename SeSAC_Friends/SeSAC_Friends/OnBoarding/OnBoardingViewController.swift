//
//  OnBoardingViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/25.
//

import UIKit

import SnapKit

class OnBoardingViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        
        collection.backgroundColor = UIColor().error
        
        return collection
    }()
    
    let pageControl = UIPageControl()
    
    let startButton = MainButton(status: .fill)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OnBoardingTitleCollectionViewCell.self, forCellWithReuseIdentifier: "titleCell")
        
        setUp()
        setConstaints()
    }
    
    func setUp() {
        view.backgroundColor = UIColor().white

        //collection view flow layout 설정
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 0
        let width = UIScreen.main.bounds.width
        
        layout.itemSize = CGSize(width: width, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .horizontal

        collectionView.collectionViewLayout = layout
        
        collectionView.isPagingEnabled = true
        
        view.addSubview(collectionView)
        
        view.addSubview(startButton)
        
    }

    
    
    func setConstaints() {
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            //make.height.equalTo(110)
        }
        
    }
    
    
}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "titleCell", for: indexPath)

        let r : CGFloat = CGFloat.random(in: 0.5...0.9)
        let g : CGFloat = CGFloat.random(in: 0.5...0.9)
        let b : CGFloat = CGFloat.random(in: 0.5...0.9)
        
        cell.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        
        

        return cell
    }
    

    
   
}

//activity indicator?!
//page controll


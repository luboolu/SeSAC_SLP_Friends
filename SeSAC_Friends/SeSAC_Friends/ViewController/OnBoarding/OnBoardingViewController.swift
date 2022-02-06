//
//  OnBoardingViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class OnBoardingViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        
        collection.backgroundColor = UIColor().error
        
        return collection
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        
        pageControl.backgroundColor = UIColor().white
        pageControl.pageIndicatorTintColor = UIColor().gray5
        pageControl.currentPageIndicatorTintColor = UIColor().black
        pageControl.tintColor = UIColor().gray5
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        
        return pageControl
    }()
    
    let startButton: MainButton = {
        let button = MainButton()
        
        button.status = .fill
        button.isBorder = true
        button.isRounded = true
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        setUp()
        setConstaints()
        setButton()
    }
    
    func setUp() {
        view.backgroundColor = UIColor().white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OnBoardingTitleCollectionViewCell.self, forCellWithReuseIdentifier: "titleCell")

        //collection view flow layout 설정
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 0
        let width = UIScreen.main.bounds.width

        layout.itemSize = CGSize(width: width, height: UIScreen.main.bounds.height - 180)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .horizontal

        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor().white
        view.addSubview(collectionView)
        
        view.addSubview(pageControl)
        //startButton.status = .fill
        startButton.setTitle("시작하기", for: .normal)
        view.addSubview(startButton)
        
    }

    
    
    func setConstaints() {
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            //make.height.equalTo(110)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(48)
        }
        
    }
    
    func setButton() {
        
        startButton.rx.tap
            .bind {
                self.startButtonTapped()
            }
        
    }
    
    func startButtonTapped() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: LoginViewController())
        windowScene.windows.first?.makeKeyAndVisible()
    }
    
}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "titleCell", for: indexPath)
        let customView = OnboardingView()
        
        if indexPath.row == 0 {

            customView.titleLabel.text = "위치 기반으로 빠르게\n주위 친구를 확인"
            
            let attributedString = NSMutableAttributedString(string: customView.titleLabel.text!)
            
            attributedString.addAttribute(.foregroundColor, value: UIColor().green, range: (customView.titleLabel.text! as NSString).range(of:"위치 기반"))
            customView.titleLabel.attributedText = attributedString
            customView.imageView.image = UIImage(named: "onboarding_img1")
            
        } else if indexPath.row == 1 {

            customView.titleLabel.text = "관심사가 같은 친구를\n찾을 수 있어요"
            
            let attributedString = NSMutableAttributedString(string: customView.titleLabel.text!)
            
            attributedString.addAttribute(.foregroundColor, value: UIColor().green, range: (customView.titleLabel.text! as NSString).range(of:"관심사가 같은 친구"))
            customView.titleLabel.attributedText = attributedString
            
            customView.imageView.image = UIImage(named: "onboarding_img2")
            
        } else {

            customView.titleLabel.text = "SeSAC Friends"
            customView.imageView.image = UIImage(named: "onboarding_img3")
        }
        
        cell.addSubview(customView)
        
        customView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //collection view가 스크롤될 때, pageControl 또한 바뀌도록 함!
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 { // Switch the location of the page.
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        }
    }
    
}

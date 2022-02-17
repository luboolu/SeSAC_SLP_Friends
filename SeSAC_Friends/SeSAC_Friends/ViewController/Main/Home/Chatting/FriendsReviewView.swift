//
//  FriendsReviewView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/17.
//
import UIKit

import SnapKit

final class FriendsReviewView: UIView, ViewRepresentable {
    
    let reviewView = UIView()
    
    let titleView = UIView()
    
    let viewTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "리뷰 등록"
        label.textColor = UIColor().black
        label.font = UIFont().Title3_M14
        label.textAlignment = .center
        
        return label
    }()
    
    let viewSubTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "000님과의 취미 활동은 어떠셨나요?"
        label.textColor = UIColor().green
        label.font = UIFont().Title4_R14
        label.textAlignment = .center
        
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "close"), for: .normal)
        
        return button
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
        //배경 투명도 설정
        self.backgroundColor = UIColor(cgColor: CGColor(gray: 0, alpha: 0.5))
        
        reviewView.clipsToBounds = true
        reviewView.layer.cornerRadius = 20
        reviewView.backgroundColor = UIColor().error
        
        titleView.addSubview(viewTitleLabel)
        titleView.addSubview(viewSubTitleLabel)
        titleView.addSubview(dismissButton)
        
        reviewView.addSubview(titleView)
        
        self.addSubview(reviewView)
        
    }
     
    func setupConstraints() {
        reviewView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(200)
        }
        
        //타이틀뷰 레이아웃 설정
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        viewTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
        }
        
        viewSubTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(viewTitleLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(viewTitleLabel.snp.trailing)
            make.trailing.equalToSuperview()
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
    }
    
    
}

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
    
    //reputation button
    let reputationButtonView = UIView()
    
    let reputationButton1: MainButton = {
        let button = MainButton()
        
        button.isBorder = true
        button.isRounded = true
        button.status = .inactive
        button.setTitle("좋은 매너", for: .normal)
        button.titleLabel?.font = UIFont().Title4_R14
        
        return button
    }()
    
    let reputationButton2: MainButton = {
        let button = MainButton()
        
        button.isBorder = true
        button.isRounded = true
        button.status = .inactive
        button.setTitle("정확한 시간 약속", for: .normal)
        button.titleLabel?.font = UIFont().Title4_R14
        
        return button
    }()
    
    let reputationButton3: MainButton = {
        let button = MainButton()
        
        button.isBorder = true
        button.isRounded = true
        button.status = .inactive
        button.setTitle("빠른 응답", for: .normal)
        button.titleLabel?.font = UIFont().Title4_R14
        
        return button
    }()
    
    let reputationButton4: MainButton = {
        let button = MainButton()
        
        button.isBorder = true
        button.isRounded = true
        button.status = .inactive
        button.setTitle("친절한 성격", for: .normal)
        button.titleLabel?.font = UIFont().Title4_R14
        
        return button
    }()
    
    let reputationButton5: MainButton = {
        let button = MainButton()
        
        button.isBorder = true
        button.isRounded = true
        button.status = .inactive
        button.setTitle("능숙한 취미 실력", for: .normal)
        button.titleLabel?.font = UIFont().Title4_R14
        
        return button
    }()
    
    let reputationButton6: MainButton = {
        let button = MainButton()
        
        button.isBorder = true
        button.isRounded = true
        button.status = .inactive
        button.setTitle("유익한 시간", for: .normal)
        button.titleLabel?.font = UIFont().Title4_R14
        
        return button
    }()
    
    let reviewTextView: UITextView = {
        let textView = UITextView()
        
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 8
        textView.backgroundColor = UIColor().gray1
        textView.text = "자세한 피드백은 다른 새싹들에게 도움이 됩니다(500자 이내 작성"
        textView.textColor = UIColor().gray7
        textView.font = UIFont().Body3_R14
        textView.isScrollEnabled = true
        
        return textView
    }()
    
    let registerButton: MainButton = {
        let button = MainButton()
        
        button.isBorder = true
        button.isRounded = true
        button.status = .disable
        button.setTitle("리뷰 등록하기", for: .normal)
        button.titleLabel?.font = UIFont().Body3_R14
        
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
        reviewView.backgroundColor = UIColor().white
        
        titleView.addSubview(viewTitleLabel)
        titleView.addSubview(viewSubTitleLabel)
        titleView.addSubview(dismissButton)
        reviewView.addSubview(titleView)
        
        //reputation button
        reputationButtonView.addSubview(reputationButton1)
        reputationButtonView.addSubview(reputationButton2)
        reputationButtonView.addSubview(reputationButton3)
        reputationButtonView.addSubview(reputationButton4)
        reputationButtonView.addSubview(reputationButton5)
        reputationButtonView.addSubview(reputationButton6)
        reviewView.addSubview(reputationButtonView)
        
        reviewView.addSubview(reviewTextView)
        reviewView.addSubview(registerButton)
        
        self.addSubview(reviewView)
        
    }
     
    func setupConstraints() {
        reviewView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        //타이틀뷰 레이아웃 설정
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(62)
        }
        
        viewTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
        }
        
        viewSubTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(viewTitleLabel.snp.bottom).offset(17)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(viewTitleLabel.snp.trailing)
            make.trailing.equalToSuperview()
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        //reputation button view 레이아웃
        reputationButtonView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        reputationButton1.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(32)
        }
        
        reputationButton2.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(reputationButton1.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(reputationButton1.snp.width)
        }
        
        reputationButton3.snp.makeConstraints { make in
            make.top.equalTo(reputationButton1.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.height.equalTo(32)
        }
        
        reputationButton4.snp.makeConstraints { make in
            make.top.equalTo(reputationButton2.snp.bottom).offset(8)
            make.leading.equalTo(reputationButton3.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(reputationButton3.snp.width)
        }
        
        reputationButton5.snp.makeConstraints { make in
            make.top.equalTo(reputationButton3.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(32)
        }
        
        reputationButton6.snp.makeConstraints { make in
            make.top.equalTo(reputationButton4.snp.bottom).offset(8)
            make.leading.equalTo(reputationButton5.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(reputationButton5.snp.width)
        }
        
        //리뷰 텍스트 뷰
        reviewTextView.snp.makeConstraints { make in
            make.top.equalTo(reputationButtonView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(124)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(reviewTextView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }
    
    
}

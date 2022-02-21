//
//  MyPopUpView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/21.
//

import UIKit

import SnapKit

final class RequestPopUpView: UIView, ViewRepresentable {
    
    let dodgeView = UIView()
    
    let titleView = UIView()
    
    let viewTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "약속을 취소하겠습니까?"
        label.textColor = UIColor().black
        label.font = UIFont().Body1_M16
        label.textAlignment = .center
        
        return label
    }()
    
    let viewSubTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "약속을 취소하시면 패널티가 부과됩니다"
        label.textColor = UIColor().black
        label.font = UIFont().Title4_R14
        label.textAlignment = .center
        
        return label
    }()
    
    let buttonView = UIView()
    
    let cancleButton: MainButton = {
        let button = MainButton()
        
        button.isBorder = true
        button.isRounded = true
        button.status = .cancel
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont().Body3_R14
        
        return button
    }()
    
    let confirmButton: MainButton = {
        let button = MainButton()
        
        button.isBorder = true
        button.isRounded = true
        button.status = .fill
        button.setTitle("확인", for: .normal)
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

        dodgeView.clipsToBounds = true
        dodgeView.layer.cornerRadius = 20
        dodgeView.backgroundColor = UIColor().white
        
        titleView.addSubview(viewTitleLabel)
        titleView.addSubview(viewSubTitleLabel)
        dodgeView.addSubview(titleView)
        
        buttonView.addSubview(cancleButton)
        buttonView.addSubview(confirmButton)
        dodgeView.addSubview(buttonView)
        
        self.addSubview(dodgeView)
    }
     
    func setupConstraints() {
        dodgeView.snp.makeConstraints { make in
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
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        viewSubTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(viewTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        cancleButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(48)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(cancleButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(cancleButton.snp.width)
        }
    }
}

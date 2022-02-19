//
//  FriendsReportView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/19.
//

import UIKit

import SnapKit

final class FriendsReportView: UIView, ViewRepresentable {
    
    let reportView = UIView()
    
    let titleView = UIView()
    
    let viewTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "새싹 신고"
        label.textColor = UIColor().black
        label.font = UIFont().Title3_M14
        label.textAlignment = .center
        
        return label
    }()
    
    let viewSubTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "다시는 해당 새싹과 매칭되지 않습니다"
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
    let reportButtonView = UIView()
    
    let reportButton1: MainButton = {
        let button = MainButton()
        
        button.isBorder = true
        button.isRounded = true
        button.status = .inactive
        button.setTitle("불법/사기", for: .normal)
        button.titleLabel?.font = UIFont().Title4_R14
        
        return button
    }()
    
    let reportButton2: MainButton = {
        let button = MainButton()
        
        button.isBorder = true
        button.isRounded = true
        button.status = .inactive
        button.setTitle("불편한언행", for: .normal)
        button.titleLabel?.font = UIFont().Title4_R14
        
        return button
    }()
    
    let reportButton3: MainButton = {
        let button = MainButton()
        
        button.isBorder = true
        button.isRounded = true
        button.status = .inactive
        button.setTitle("노쇼", for: .normal)
        button.titleLabel?.font = UIFont().Title4_R14
        
        return button
    }()
    
    let reportButton4: MainButton = {
        let button = MainButton()
        
        button.isBorder = true
        button.isRounded = true
        button.status = .inactive
        button.setTitle("선정성", for: .normal)
        button.titleLabel?.font = UIFont().Title4_R14
        
        return button
    }()
    
    let reportButton5: MainButton = {
        let button = MainButton()
        
        button.isBorder = true
        button.isRounded = true
        button.status = .inactive
        button.setTitle("인신공격", for: .normal)
        button.titleLabel?.font = UIFont().Title4_R14
        
        return button
    }()
    
    let reportButton6: MainButton = {
        let button = MainButton()
        
        button.isBorder = true
        button.isRounded = true
        button.status = .inactive
        button.setTitle("기타", for: .normal)
        button.titleLabel?.font = UIFont().Title4_R14
        
        return button
    }()
    
    let reportTextView: UITextView = {
        let textView = UITextView()
        
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 8
        textView.backgroundColor = UIColor().gray1
        textView.text = "신고 사유를 적어주세요 \n허위 신고 시 제재를 받을 수 있습니다"
        textView.textColor = UIColor().gray7
        textView.font = UIFont().Body3_R14
        textView.isScrollEnabled = true
        
        return textView
    }()
    
    let reportButton: MainButton = {
        let button = MainButton()
        
        button.isBorder = true
        button.isRounded = true
        button.status = .disable
        button.setTitle("신고하기", for: .normal)
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
        self.backgroundColor = UIColor(cgColor: CGColor(gray: 0, alpha: 0.5))
        
        reportView.clipsToBounds = true
        reportView.layer.cornerRadius = 20
        reportView.backgroundColor = UIColor().white

        titleView.addSubview(viewTitleLabel)
        titleView.addSubview(viewSubTitleLabel)
        titleView.addSubview(dismissButton)
        reportView.addSubview(titleView)
        
        //report button
        reportButtonView.addSubview(reportButton1)
        reportButtonView.addSubview(reportButton2)
        reportButtonView.addSubview(reportButton3)
        reportButtonView.addSubview(reportButton4)
        reportButtonView.addSubview(reportButton5)
        reportButtonView.addSubview(reportButton6)
        reportView.addSubview(reportButtonView)
        
        reportView.addSubview(reportTextView)
        reportView.addSubview(reportButton)
        
        self.addSubview(reportView)
    }
    
    func setupConstraints() {
        reportView.snp.makeConstraints { make in
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
        
        //report button view 레이아웃
        reportButtonView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        reportButton1.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(32)
        }
        
        reportButton2.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(reportButton1.snp.trailing).offset(8)
            make.height.equalTo(32)
            make.width.equalTo(reportButton1.snp.width)
        }
        
        reportButton3.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(reportButton2.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(reportButton1.snp.width)
        }
        
        reportButton4.snp.makeConstraints { make in
            make.top.equalTo(reportButton1.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(32)
        }
        
        reportButton5.snp.makeConstraints { make in
            make.top.equalTo(reportButton2.snp.bottom).offset(8)
            make.leading.equalTo(reportButton4.snp.trailing).offset(8)
            make.bottom.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(reportButton4.snp.width)
        }
        
        reportButton6.snp.makeConstraints { make in
            make.top.equalTo(reportButton3.snp.bottom).offset(8)
            make.leading.equalTo(reportButton5.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(reportButton4.snp.width)
        }
        
        //텍스트 뷰
        reportTextView.snp.makeConstraints { make in
            make.top.equalTo(reportButtonView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(124)
        }
        
        reportButton.snp.makeConstraints { make in
            make.top.equalTo(reportTextView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }
}

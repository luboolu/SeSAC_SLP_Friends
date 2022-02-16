//
//  ChattingView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/15.
//
import UIKit

final class ChattingView: UIView, ViewRepresentable {
    
    let messageView = UIView()
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        
        textView.text = "메세지를 입력하세요"
        textView.isScrollEnabled = false
        textView.font = UIFont().Body3_R14
        textView.textColor = UIColor().gray7
        textView.backgroundColor = UIColor().gray1
        
        return textView
    }()
    
    let messageButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "message_send"), for: .normal)
        button.isEnabled = false
        
        return button
    }()
    
    let chattingTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    let menuStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.backgroundColor = UIColor().white
        
        return stackView
    }()
    
    let reportButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setTitle("새싹 신고", for: .normal)
        button.titleLabel?.font = UIFont().Title3_M14
        button.setTitleColor(UIColor().black, for: .normal)
        button.setImage(UIImage(named: "siren"), for: .normal)
        button.isHidden = true
        button.contentVerticalAlignment = .center
        
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "siren"), for: .normal)
        button.setTitle("약속 취소", for: .normal)
        button.titleLabel?.font = UIFont().Title3_M14
        button.setTitleColor(UIColor().black, for: .normal)
        button.isHidden = true
        
        return button
    }()
    
    let reviewButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "write"), for: .normal)
        button.setTitle("리뷰 등록", for: .normal)
        button.titleLabel?.font = UIFont().Title3_M14
        button.setTitleColor(UIColor().black, for: .normal)
        button.isHidden = true
        
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
        self.backgroundColor = UIColor().white
        
        self.addSubview(chattingTableView)
        
        messageView.backgroundColor = UIColor().gray1
        messageView.clipsToBounds = true
        messageView.layer.cornerRadius = 8
        
        messageView.addSubview(messageTextView)
        messageView.addSubview(messageButton)
        self.addSubview(messageView)
        
        menuStackView.addArrangedSubview(reportButton)
        menuStackView.addArrangedSubview(cancelButton)
        menuStackView.addArrangedSubview(reviewButton)
        self.addSubview(menuStackView)
    }
     
    func setupConstraints() {
        
        menuStackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        reportButton.snp.makeConstraints { make in
            make.height.equalTo(72)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(72)
        }
        
        reviewButton.snp.makeConstraints { make in
            make.height.equalTo(72)
        }
        
        chattingTableView.snp.makeConstraints { make in
            make.top.equalTo(menuStackView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(messageView.snp.top)
        }
        
        messageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(messageButton.snp.leading).offset(-10)
            make.bottom.equalToSuperview().offset(-14)
            make.height.lessThanOrEqualTo(100)
        }
        
        messageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-14)
            make.width.equalTo(20)
        }
    }
    
    
}

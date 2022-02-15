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
    }
     
    func setupConstraints() {
        
        chattingTableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
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

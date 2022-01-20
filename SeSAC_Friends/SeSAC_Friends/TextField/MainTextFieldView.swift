//
//  MainTextFieldView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/19.
//

import UIKit

import SnapKit

class MainTextFieldView: UIView {
    
    let textfield = UITextField()
    let borderLabel = UILabel()
    let commentLabel = UILabel()
    
    let stackview: UIStackView = {
        let stackview = UIStackView()
        
        stackview.axis = .vertical
        stackview.spacing = 10
        stackview.distribution = .equalSpacing
        stackview.alignment = .center
        
        return stackview
    }()
    
    var status: MainTextFieldStatus = .inactive {
        didSet {
            switch status {
            case .inactive:
                commentLabel.isHidden = true
                
                borderLabel.backgroundColor = UIColor().gray3
                textfield.attributedPlaceholder = NSAttributedString(string: "내용을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor().gray7])
                
            case .focus:
                commentLabel.isHidden = true
                borderLabel.backgroundColor = UIColor().black
                textfield.attributedPlaceholder = NSAttributedString(string: "내용을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor().black])
                textfield.textColor = UIColor().black
                
            case .active:
                commentLabel.isHidden = true
                borderLabel.backgroundColor = UIColor().gray3
                textfield.attributedPlaceholder = NSAttributedString(string: "내용을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor().black])
                textfield.textColor = UIColor().black
                
            case .disable:
                commentLabel.isHidden = true
                borderLabel.isHidden = true
                
                self.backgroundColor = UIColor().gray3
                borderLabel.backgroundColor = UIColor().gray3
                textfield.attributedPlaceholder = NSAttributedString(string: "내용을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor().gray7])

            case .error:
                commentLabel.isHidden = false
                borderLabel.backgroundColor = UIColor().error
                commentLabel.textColor = UIColor().error
                textfield.attributedPlaceholder = NSAttributedString(string: "내용을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor().black])
                textfield.textColor = UIColor().black
                commentLabel.text = "에러"
                
            case .success:
                commentLabel.isHidden = false
                borderLabel.backgroundColor = UIColor().success
                commentLabel.textColor = UIColor().success
                textfield.attributedPlaceholder = NSAttributedString(string: "내용을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor().black])
                textfield.textColor = UIColor().black
                commentLabel.text = "성공"
            }
        }
    }
    
    convenience init(status: MainTextFieldStatus) {
        self.init()
        setUp()
        setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setUp() {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        
        stackview.addArrangedSubview(textfield)
        stackview.addArrangedSubview(borderLabel)
        stackview.addArrangedSubview(commentLabel)
        
        self.addSubview(stackview)
    }
    
    func setConstraints() {
        stackview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }

        textfield.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        borderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        commentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
}


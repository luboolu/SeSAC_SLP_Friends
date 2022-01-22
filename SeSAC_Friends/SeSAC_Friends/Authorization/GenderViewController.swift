//
//  genderViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/21.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class GenderViewController: UIViewController {
    
    let guideLabel1: UILabel = {
        let label = UILabel()
        
        label.text = "성별을 선택해 주세요"
        label.textColor = UIColor().black
        label.font = UIFont().Display1_R20
        label.textAlignment = .center
        
        return label
    }()
    
    let guideLabel2: UILabel = {
        let label = UILabel()
        
        label.text = "새싹 찾기 기능을 이용하기 위해서 필요해요"
        label.textColor = UIColor().gray7
        label.font = UIFont().Title2_R16
        label.textAlignment = .center
        
        return label
    }()
    
    let manButtonView = UIView()
    
    let manButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "man"), for: .normal)
        
        return button
    }()
    
    let manLabel: UILabel = {
        let label = UILabel()
        
        label.text = "남자"
        label.textAlignment = .center
        
        return label
    }()
    
    let womanButtonView = UIView()
    
    let womanButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "woman"), for: .normal)
        
        return button
    }()
    
    let womanLabel: UILabel = {
        let label = UILabel()
        
        label.text = "여자"
        label.textAlignment = .center
        
        return label
    }()
    
    let nextButton = MainButton(status: .disable)
    
    var isMan = false
    var isWoman = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setConstaints()
        
        manButton.rx.tap
            .bind {
                
                self.isMan = !self.isMan

                if self.isMan {
                    self.isWoman = false
                    
                    self.womanButtonView.backgroundColor = UIColor().white
                    self.manButtonView.backgroundColor = UIColor().whitegreen
                } else {
                    self.isWoman = false
                    
                    self.manButtonView.backgroundColor = UIColor().white
                }
                print("man: \(self.isMan) woman: \(self.isWoman)")
                
                
            }
        
        womanButton.rx.tap
            .bind {
                self.isWoman = !self.isWoman

                if self.isWoman {
                    self.isMan = false
                    
                    self.womanButtonView.backgroundColor = UIColor().whitegreen
                    self.manButtonView.backgroundColor = UIColor().white
                } else {
                    self.isMan = false
                    
                    self.womanButtonView.backgroundColor = UIColor().white
                }
                print("man: \(self.isMan) woman: \(self.isWoman)")
            }
        
    }
    
    func setUp() {
        
        view.backgroundColor = UIColor().white
        
        view.addSubview(guideLabel1)
        view.addSubview(guideLabel2)
        
        manButtonView.clipsToBounds = true
        manButtonView.layer.cornerRadius = 10
        manButtonView.layer.borderWidth = 1
        manButtonView.layer.borderColor = UIColor().gray3.cgColor
        manButtonView.addSubview(manButton)
        manButtonView.addSubview(manLabel)
        view.addSubview(manButtonView)
        
        womanButtonView.clipsToBounds = true
        womanButtonView.layer.cornerRadius = 10
        womanButtonView.layer.borderWidth = 1
        womanButtonView.layer.borderColor = UIColor().gray3.cgColor
        womanButtonView.addSubview(womanButton)
        womanButtonView.addSubview(womanLabel)
        view.addSubview(womanButtonView)
        
        nextButton.setTitle("다음", for: .normal)
        view.addSubview(nextButton)
        
    }
    
    func setConstaints() {
        
        guideLabel1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.centerX.equalToSuperview()
        }
        
        guideLabel2.snp.makeConstraints { make in
            make.top.equalTo(guideLabel1.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        manButtonView.snp.makeConstraints { make in
            make.top.equalTo(guideLabel2.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(womanButtonView.snp.leading).offset(-8)
            make.height.equalTo(120)
        }
        
        womanButtonView.snp.makeConstraints { make in
            make.top.equalTo(guideLabel2.snp.bottom).offset(32)
            make.leading.equalTo(manButtonView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(manButtonView.snp.width).multipliedBy(1)
            make.height.equalTo(120)
        }
        
        manButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        manLabel.snp.makeConstraints { make in
            make.top.equalTo(manButton.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-14)
        }
        
        womanButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        womanLabel.snp.makeConstraints { make in
            make.top.equalTo(womanButton.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-14)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(manButtonView.snp.bottom).offset(46)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }
}

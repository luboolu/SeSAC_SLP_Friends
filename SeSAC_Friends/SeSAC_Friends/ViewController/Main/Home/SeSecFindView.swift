//
//  SeSecFindView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/08.
//

import UIKit

import SnapKit

final class SeSacFindView: UIView, ViewRepresentable {
    
    let segmentView = UIView()
    
    let mySegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["주변 새싹", "받은 요청"])
        
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = UIColor().white
        segment.selectedSegmentTintColor = UIColor().white
                
        return segment
    }()
    
    let buttonView = UIView()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        //stackView.backgroundColor = UIColor().error
        
        return stackView
    }()
    
    let near = UIView()
    
    let nearViewButton: MainButton = {
        let button = MainButton()
        
        button.status = .outline
        button.isRounded = false
        button.isBorder = false
        button.setTitle("주변 새싹", for: .normal)
        button.titleLabel?.font = UIFont().Title3_M14
        
        return button
    }()
    
    let nearViewLine: MainButton = {
        let button = MainButton()
        
        button.status = .fill
        button.isRounded = false
        button.isBorder = false
        button.setTitle("", for: .normal)
        
        return button
    }()
    
    let recived = UIView()
    
    let recivedViewButton: MainButton = {
        let button = MainButton()
        
        button.status = .inactive
        button.isRounded = false
        button.isBorder = false
        button.setTitle("받은 요청", for: .normal)
        button.titleLabel?.font = UIFont().Title3_M14
        
        return button
    }()
    
    let recivedViewLine: MainButton = {
        let button = MainButton()
        
        button.status = .inactive
        button.isRounded = false
        button.isBorder = false
        button.setTitle("", for: .normal)
        
        return button
    }()
    
    let contentView = UIView()
    
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
        //buttonStackView.backgroundColor = UIColor().error
        //near.backgroundColor = UIColor().green
        near.addSubview(nearViewButton)
        near.addSubview(nearViewLine)
        
        buttonStackView.addArrangedSubview(near)
        
        recived.addSubview(recivedViewButton)
        recived.addSubview(recivedViewLine)
        
        buttonStackView.addArrangedSubview(recived)
        
        self.addSubview(buttonStackView)
        contentView.backgroundColor = UIColor().error
        self.addSubview(contentView)
    }
    
    func setupConstraints() {
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
        
        near.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        nearViewButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        nearViewLine.snp.makeConstraints { make in
            make.top.equalTo(nearViewButton.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        recived.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        recivedViewButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        recivedViewLine.snp.makeConstraints { make in
            make.top.equalTo(recivedViewButton.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        
    }
    
    func useSegmentControl() {
        segmentView.backgroundColor = UIColor().green
        segmentView.addSubview(mySegment)
        self.addSubview(segmentView)
        
        segmentView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
        
        mySegment.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    
}

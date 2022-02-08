//
//  NearSeSacView.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/08.
//
import UIKit

final class NearSeSacView: UIView, ViewRepresentable {
    
    let testLabel: UILabel = {
        let label = UILabel()
        
        label.text = "근처 새싹"
        
        return label
    }()
    
    let testButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor.systemBlue
        
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
        self.backgroundColor = UIColor().whitegreen
        self.addSubview(testLabel)
        self.addSubview(testButton)
    }
     
    func setupConstraints() {
        testLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        testButton.snp.makeConstraints { make in
            make.top.equalTo(testLabel.snp.bottom)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    
}

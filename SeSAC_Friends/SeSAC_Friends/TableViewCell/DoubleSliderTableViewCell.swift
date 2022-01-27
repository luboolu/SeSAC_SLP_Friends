//
//  DoubleSliderTableViewCell.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/27.
//

import UIKit

import SnapKit
import MultiSlider

class DoubleSliderTableViewCell: UITableViewCell, ViewRepresentable {
    
    let label: UILabel = {
        let label = UILabel()
        
        label.font = UIFont().Title4_R14
        label.textColor = UIColor().black
        
        return label
    }()
    
    let ageLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont().Title3_M14
        label.textColor = UIColor().green
        
        return label
    }()
    
    let slider: MultiSlider = {
        let slider = MultiSlider()
        
        slider.minimumValue = 18
        slider.maximumValue = 65
        slider.valueLabelColor = UIColor().green
        slider.tintColor = UIColor().green
        slider.outerTrackColor = UIColor().gray2
        slider.orientation = .horizontal
        slider.thumbImage = UIImage(named: "filter_control")
        slider.snapStepSize = 0.5
        slider.trackWidth = 5
        slider.value = [20, 40]
        
        return slider
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func setupView() {
        contentView.addSubview(label)
        contentView.addSubview(ageLabel)
        contentView.addSubview(slider)
    }
    
    func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(14)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalTo(label.snp.trailing).offset(14)
            make.trailing.equalToSuperview().offset(-14)
        }
        
        slider.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
            make.bottom.equalToSuperview().offset(-14)
        }
        

    }
    
    
}

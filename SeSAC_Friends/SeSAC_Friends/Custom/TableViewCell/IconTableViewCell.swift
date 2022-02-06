//
//  IconTableViewCell.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/26.
//

import UIKit
import SnapKit

final class IconTableViewCell: UITableViewCell {
    
    let icon: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        
        label.font = UIFont().Title2_R16
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func setUp() {
        self.addSubview(icon)
        self.addSubview(label)
    }
    
    func setConstraints() {
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(19)
            make.width.equalTo(20)
            make.height.equalTo(icon.snp.width).multipliedBy(1)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(icon.snp.trailing).offset(14)
            make.trailing.equalToSuperview().offset(-14)
        }
    }

}

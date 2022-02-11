//
//  HomeViewswift.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/03.
//

import UIKit
import MapKit
import CoreLocation
import CoreLocationUI

import SnapKit

final class HomeView: UIView, ViewRepresentable {
    
    let mapView = MKMapView()
    
    let centerMarker: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "map_marker")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let genderView = UIView()
    
    let genderStackView: UIStackView = {
        let stackview = UIStackView()
        
        stackview.axis = .vertical
        stackview.spacing = 0
        stackview.distribution = .fillEqually
        stackview.alignment = .center
        stackview.clipsToBounds = true
        stackview.layer.cornerRadius = 8
        
        return stackview
    }()
    
    let genderButton1: MainButton = {
        let button = MainButton()
        
        button.status = .fill
        button.isBorder = false
        button.isRounded = false
        button.setTitle("전체", for: .normal)
        button.titleLabel?.font = UIFont().Title4_R14
        
        return button
    }()
    
    let genderButton2: MainButton = {
        let button = MainButton()
        
        button.status = .inactive
        button.isBorder = false
        button.isRounded = false
        button.setTitle("남자", for: .normal)
        button.titleLabel?.font = UIFont().Title4_R14
        
        return button
    }()
    
    let genderButton3: MainButton = {
        let button = MainButton()
        
        button.status = .inactive
        button.isBorder = false
        button.isRounded = false
        button.setTitle("여자", for: .normal)
        button.titleLabel?.font = UIFont().Title4_R14
        
        return button
    }()
    
    let locationButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor().white
        button.setImage(UIImage(named: "place"), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor().black.cgColor // 색깔
        button.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        button.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        button.layer.shadowRadius = 3 // 반경
        button.layer.shadowOpacity = 0.3 // alpha값
        
        return button
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "default_button"), for: .normal)
        button.layer.shadowColor = UIColor().black.cgColor // 색깔
        button.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        button.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        button.layer.shadowRadius = 3 // 반경
        button.layer.shadowOpacity = 0.3 // alpha값
        
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
        
        self.addSubview(mapView)
        self.addSubview(searchButton)
        self.addSubview(centerMarker)
        
        genderStackView.addArrangedSubview(genderButton1)
        genderStackView.addArrangedSubview(genderButton2)
        genderStackView.addArrangedSubview(genderButton3)
        
        //뷰 그림자
        genderView.layer.shadowColor = UIColor().black.cgColor // 색깔
        genderView.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        genderView.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        genderView.layer.shadowRadius = 3 // 반경
        genderView.layer.shadowOpacity = 0.3 // alpha값
        
        genderView.addSubview(genderStackView)
        self.addSubview(genderView)
        self.addSubview(locationButton)
    }
    
    func setupConstraints() {
        
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        searchButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(64)
            make.height.equalTo(searchButton.snp.width).multipliedBy(1)
        }
        
        centerMarker.snp.makeConstraints { make in
            make.centerX.equalTo(mapView)
            make.centerY.equalTo(mapView)
        }
        
        genderView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(48)
            make.height.equalTo(144)
        }
        
        genderStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        genderButton1.snp.makeConstraints { make in
            make.width.equalTo(genderButton1.snp.height).multipliedBy(1)
        }

        genderButton2.snp.makeConstraints { make in
            make.width.equalTo(genderButton2.snp.height).multipliedBy(1)
        }

        genderButton3.snp.makeConstraints { make in
            make.width.equalTo(genderButton3.snp.height).multipliedBy(1)
        }
        
        locationButton.snp.makeConstraints { make in
            make.top.equalTo(genderStackView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
    }
    
    
}

//
//  MainViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/22.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import CoreLocation
import MapKit

final class HomeViewController: UIViewController {

    private let mainView = HomeView()
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = UIColor().gray7
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        locationManager.delegate = self
        mainView.mapView.delegate = self
        
        setupMap()
        setupButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupMap() {
        //37.556124592490924, 126.97235991352282
        let location = CLLocationCoordinate2D(latitude: 37.556124592490924, longitude: 126.97235991352282)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mainView.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = "Here!"
        annotation.coordinate = location
        mainView.mapView.addAnnotation(annotation)
    }
    
    private func setupButton() {
        //searchButton
        mainView.searchButton.rx.tap
            .bind {
                print("tapped!")
                let vc = HobbySearchViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        //gender filter button
        mainView.genderButton1.rx.tap
            .scan(mainView.genderButton1.status) { lastState, newState in
                self.mainView.genderButton2.status = .inactive
                self.mainView.genderButton3.status = .inactive
                return .fill
            }
            .map{ $0 }
            .bind(to: mainView.genderButton1.rx.status)
            .disposed(by: disposeBag)
        
        mainView.genderButton2.rx.tap
            .scan(mainView.genderButton1.status) { lastState, newState in
                self.mainView.genderButton1.status = .inactive
                self.mainView.genderButton3.status = .inactive
                return .fill
            }
            .map{ $0 }
            .bind(to: mainView.genderButton2.rx.status)
            .disposed(by: disposeBag)
        
        mainView.genderButton3.rx.tap
            .scan(mainView.genderButton1.status) { lastState, newState in
                self.mainView.genderButton1.status = .inactive
                self.mainView.genderButton2.status = .inactive
                return .fill
            }
            .map{ $0 }
            .bind(to: mainView.genderButton3.rx.status)
            .disposed(by: disposeBag)
        
        mainView.locationButton.rx.tap
            .bind {
                print("location button tap")
                self.updateLocation()
            }.disposed(by: disposeBag)
    }
    
    private func updateLocation() {
    
        locationManager.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {
            self.locationManager.stopUpdatingLocation()
            print("stop")
        }
        
    }
    
    

}

extension HomeViewController: CLLocationManagerDelegate {
    //9. iOS 버전에 따른 분기 처리와 iOS 위치 서비스 여부 확인
    func checkLocationServicesAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus =
            CLLocationManager.authorizationStatus()
        }
        
        //iOS 위치 서비스 확인
        if CLLocationManager.locationServicesEnabled() {
            //권한 상태 확인 및 권한 요청 가능(8번 메서드 실행)
            checkCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("iOS 위치 서비스를 켜주세요")
            
        }
    }
    
    //8. 사용자의 권란 상태 확인(UDF: 사용자 정의 함수로 프로토콜 내 메셔드가 아님!)
    //사용자가 위치를 허용했는지 안했는지, 거부한건지 이런 권한을 확인! (단, iOS의 위치 서비스가 가능한지 확인)
    func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest //개발자가 지정하는 위치서비스의 정확도
            locationManager.requestWhenInUseAuthorization() //앱을 사용하는 동안에 대한 위치 권한 요청
            locationManager.startUpdatingLocation() //위치 접근 시작 -> didUpdateLocations 실행
        case .restricted:
            print("DENIED, 설정으로 유도")
        case .denied:
            print("DENIED, 설정으로 유도")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            locationManager.startUpdatingLocation() //위치 접근 시작 -> didUpdateLocations 실행
        case .authorizedAlways:
            print("Always")
        @unknown default:
            print("DEFAULT")
        }
        
        if #available(iOS 14.0, *) {
            //정확도 체크: 정확도 감소가 되어 있을경우, 1시간 4번만 위치가 기록됨, 미리 알림 실행 안될수도, 대신 배터리는 오래 쓸 수 있음, 워치7부터 위치 정보가 동기화됨
            let accuarancyState = locationManager.accuracyAuthorization
            
            switch accuarancyState {
            case .fullAccuracy:
                print("FULL")
            case .reducedAccuracy:
                print("REDUCE")
            @unknown default:
                print("DEFAULT")
            }
        }
        
        
    }

    //4. 사용자가 위치 허용을 한 경우 실행되는 부분
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            
            //맵뷰의 annotation을 삭제하고자 할때
            let annotations = mainView.mapView.annotations
            mainView.mapView.removeAnnotations(annotations)
            
            let annotation = MKPointAnnotation()
            annotation.title = "Current Location"
            annotation.coordinate = coordinate
            mainView.mapView.addAnnotation(annotation)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mainView.mapView.setRegion(region, animated: true)
            print(region)
            //한글 주소 변환
//            let findLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//            let geocoder = CLGeocoder()
//            let locale = Locale(identifier: "ko-kr")
//
//            geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
//
//                if let address: [CLPlacemark] = placemarks { if let name: String = address.last?.name {
//                    print(name)
//                    //self.addressLabel.text = "\(name)"
//                } //전체 주소
//
//                }
//
//            })
//
//            nowLatitude = coordinate.latitude
//            nowLongitude = coordinate.longitude
//
//            getWeatherInfo(lat: coordinate.latitude, lon: coordinate.longitude)
                
            
            
        } else {
            print("Location Cannot Find")
        }

    }
    
    //5.위치 접근이 실패한 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
        
        let alert = UIAlertController(title: "위치 권한을 허용해주세요.", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "네", style: .default, handler: { action in
            //'네'가 눌리면 위치 권한을 설정할 수 있는 아이폰 설정 화면으로 연결
            // 설정창의 url 생성
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            // 열 수 있는 url 이라면, 이동
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }))
        self.present(alert, animated: true)
        

        
    }
    
    //6. iOS14 미만: 앱이 위치 관리자를 생성하고, 승인 상태가 변경 될 때 대리자에게 승인 상태를 알려줌
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        checkLocationServicesAuthorization()
    }
    
    //7.iOS14 이상: 앱이 위치 관리자를 생성하고, 승인 상태가 변경될 때 대리자에게 승인 상태를 알려줌
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkLocationServicesAuthorization()
    }
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("여기야!!!")
    }
}

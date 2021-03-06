//
//  MainViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/22.
//

import UIKit
import CoreLocation
import MapKit

import SnapKit
import RxCocoa
import RxSwift
import Toast


final class HomeViewController: UIViewController {

    private let mainView = HomeView()
    private let viewModel = QueueViewModel()
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private let toastStyle = ToastStyle()
    
    private var nowLocation = [37.51769437533214, 126.88639758186552]
    private var genderFilter = 2
    private var timer: Timer?

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = UIColor().black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        UserDefaults.standard.set(self.genderFilter, forKey: UserdefaultKey.genderFilter.rawValue)
        
        locationManager.delegate = self
        mainView.mapView.delegate = self
        
        setupMap()
        setupButton()
        updateLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        self.searchFriends()
        
        if timer != nil && timer!.isValid {
            timer!.invalidate()
        }
        
        //5초마다 myQueueState 실행하여 데이터 갱신
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateMyState), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if timer != nil && timer!.isValid {
            timer!.invalidate()
        }
        
    }
    
    private func setupMap() {
        //영등포 싹 캠퍼스 위치: 37.51769437533214, 126.88639758186552
        let location = CLLocationCoordinate2D(latitude: nowLocation[0], longitude: nowLocation[1])
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mainView.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mainView.mapView.addAnnotation(annotation)
    }
    
    private func setupButton() {
        //floatingButton
        mainView.floatingButton.rx.tap
            .bind {
                print("tapped!")
                self.floatingButtonClicked()
            }.disposed(by: disposeBag)
        
        //매칭 상태에 따라 floatingButton의 이미지를 바꿔줌
        UserDefaults.standard.rx
            .observe(String.self, UserdefaultKey.matchingState.rawValue)
            .subscribe(onNext: { newValue in
                DispatchQueue.main.async {
                    if newValue == matchingState.waiting.rawValue {
                        self.mainView.floatingButton.setImage(UIImage(named: "matching_button"), for: .normal)
                    } else if newValue == matchingState.matched.rawValue {
                        self.mainView.floatingButton.setImage(UIImage(named: "matched_button"), for: .normal)
                    } else {
                        self.mainView.floatingButton.setImage(UIImage(named: "default_button"), for: .normal)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        //gender filter button
        mainView.genderButton1.rx.tap
            .scan(mainView.genderButton1.status) { lastState, newState in
                self.mainView.genderButton2.status = .inactive
                self.mainView.genderButton3.status = .inactive
                //annotation 지우고 다시 보여주기
                let ants = self.mainView.mapView.annotations
                self.mainView.mapView.removeAnnotations(ants)
                
                self.genderFilter = 2
                UserDefaults.standard.set(self.genderFilter, forKey: UserdefaultKey.genderFilter.rawValue)
                print(self.genderFilter)
                self.searchFriends()
                return .fill
            }
            .map{ $0 }
            .bind(to: mainView.genderButton1.rx.status)
            .disposed(by: disposeBag)
        
        mainView.genderButton2.rx.tap
            .scan(mainView.genderButton1.status) { lastState, newState in
                self.mainView.genderButton1.status = .inactive
                self.mainView.genderButton3.status = .inactive
                //annotation 지우고 다시 보여주기
                let ants = self.mainView.mapView.annotations
                self.mainView.mapView.removeAnnotations(ants)
                
                self.genderFilter = 1
                UserDefaults.standard.set(self.genderFilter, forKey: UserdefaultKey.genderFilter.rawValue)
                print(self.genderFilter)
                self.searchFriends()
                return .fill
            }
            .map{ $0 }
            .bind(to: mainView.genderButton2.rx.status)
            .disposed(by: disposeBag)
        
        mainView.genderButton3.rx.tap
            .scan(mainView.genderButton1.status) { lastState, newState in
                self.mainView.genderButton1.status = .inactive
                self.mainView.genderButton2.status = .inactive
                //annotation 지우고 다시 보여주기
                let ants = self.mainView.mapView.annotations
                self.mainView.mapView.removeAnnotations(ants)
                
                self.genderFilter = 0
                UserDefaults.standard.set(self.genderFilter, forKey: UserdefaultKey.genderFilter.rawValue)
                print(self.genderFilter)
                self.searchFriends()
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
        
        searchFriends()
        
    }
    
    private func getRegion(location: [Double]) -> Int {
        
        let lat = String(location[0] + 90)
        let long = String(location[1] + 180)
        var region = ""

        for i in lat {
            if i != "." {
                region.append(i)
                if region.count == 5 {
                    break
                }
            }
        }
        
        for i in long {
            if i != "." {
                region.append(i)
                if region.count == 10 {
                    break
                }
            }
        }

        return Int(region) ?? 1275130688
    }
    
    private func searchFriends() {
        print(#function)
        let region = getRegion(location: self.nowLocation)

        viewModel.queueOn(region: region, lat: self.nowLocation[0], long: self.nowLocation[1]) { apiResult, queueOn, queueOnData in
            print(queueOn)
            if let queueOn = queueOn {
                switch queueOn {
                case .succeed:
                    if let queueOnData = queueOnData {
                        DispatchQueue.main.async {
                            self.markFriends(friends: queueOnData)
                        }
                    }
                case .tokenError:
                    self.searchFriends()
                    return
                case .notUser:
                    DispatchQueue.main.async {
                        //온보딩 화면으로 이동
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: OnBoardingViewController())
                        windowScene.windows.first?.makeKeyAndVisible()
                    }
                case .serverError:
                    print("에러 잠시 후 시도 ㅂㅌ")
                case .clientError:
                    print("에러 잠시 후 시도 ㅂㅌ")
                }
            }
            
        }
        
    }
    
    private func markFriends(friends: QueueOnData?) {
        
        guard let friends = friends else {
            return
        }

        //if friends.fromQueueDB.count > 0 {
        //annotation 지우고 다시 보여주기
        let ants = self.mainView.mapView.annotations
        self.mainView.mapView.removeAnnotations(ants)
        
        var annotations: [MKAnnotation] = []
        
        for data in friends.fromQueueDB {
            let annotation = MKPointAnnotation()
            print(data.nick)
            print(data.hf)
            annotation.subtitle = "\(data.sesac)"
            annotation.coordinate = CLLocationCoordinate2D(latitude: data.lat, longitude: data.long)
            
            //성별 필터
            if self.genderFilter == 2 {
                annotations.append(annotation)
            } else if self.genderFilter == data.gender {
                annotations.append(annotation)
            }

        }
        
        mainView.mapView.addAnnotations(annotations)
        //}
    }
    
    private func floatingButtonClicked() {
        //플로팅 버튼 클릭 시 flow
        //1. 위치 권한 설정 확인 -> 허용 안되어 있으면 설정 화면으로 이동
        //2. 사용자의 성별이 설정되어있어야 함(남1 or 여0) -> 안되어 있다면 "새싹찾기 기능을 사용하기 위해서는 성별이 필요해요!" 토스트 메시지 이후, 정보관리화면으로 전환
        //3. 1,2를 만족하면 취미 입력 화면으로 전환
        //+
        //사용자의 현재 상태에 따라서 취미 입력 화면으로 전환 또는 채팅 화면으로 전환
        let userGender = UserDefaults.standard.integer(forKey: UserdefaultKey.gender.rawValue)
        
        if userGender == 2 {
            self.view.makeToast("새싹 찾기 기능을 사용하기 위해서는 성별이 필요해요!", duration: 2.0, position: .bottom, style: self.toastStyle)
            return
        } else {
            let state = UserDefaults.standard.string(forKey: UserdefaultKey.matchingState.rawValue)
            
            if state == matchingState.matched.rawValue {
                //매칭된 상태이면 채팅 화면으로 이동
                DispatchQueue.main.async {
                    let vc = ChattingViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                //일반상태 또는 매칭 대기중이면 취미 입력 화면으로 이동
                DispatchQueue.main.async {
                    let vc = HobbySearchViewController()
                    let region = self.getRegion(location: self.nowLocation)
                    
                    vc.region = region
                    vc.userLocation = self.nowLocation
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
    
    @objc private func updateMyState() {
        print(#function)
        
        let state = UserDefaults.standard.string(forKey: UserdefaultKey.matchingState.rawValue)
        
        if state == matchingState.noState.rawValue || state == nil {
            return
        }
        
        viewModel.queueMyState { apiResult, queueState, myQueueState in
            if let queueState = queueState {
                switch queueState {
                case .succeed:
                    if let myQueueState = myQueueState {
                        print(myQueueState)
                        DispatchQueue.main.async {
                            if myQueueState.matched == 1 {
                                //매칭된 상태이므로 토스트 메세지를 띄우고, 채팅방으로 이동
                                self.view.makeToast("\(String(describing: myQueueState.matchedNick ?? ""))님과 매칭되셨습니다. 채팅 기능을 이용할 수 있습니다." ,duration: 2.0, position: .bottom, style: self.toastStyle)
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                                    //매칭 상태 변경
                                    UserDefaults.standard.set(matchingState.matched.rawValue, forKey: UserdefaultKey.matchingState.rawValue)
                                    
                                    if self.timer != nil && self.timer!.isValid {
                                        self.timer!.invalidate()
                                    }
                                }
                            }
                        }
                    }
                case .stopped:
                    DispatchQueue.main.async {
                        self.view.makeToast("오랜 시간 동안 매칭되지 않아 새싹 친구 찾기를 그만둡니다." ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    }
                case .tokenError:
                    self.updateMyState()
                    return
                case .notUser:
                    DispatchQueue.main.async {
                        //온보딩 화면으로 이동
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: OnBoardingViewController())
                        windowScene.windows.first?.makeKeyAndVisible()
                    }
                case .serverError:
                    DispatchQueue.main.async {
                        self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    }
                case .clientError:
                    DispatchQueue.main.async {
                        self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요" ,duration: 2.0, position: .bottom, style: self.toastStyle)
                    }
                }
            }
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
            
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mainView.mapView.setRegion(region, animated: true)

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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        annotationView.markerTintColor = UIColor.clear
        annotationView.canShowCallout = false
        let size = CGSize(width: 83, height: 83)
        UIGraphicsBeginImageContext(size)
        
        switch annotation.subtitle! {
        case "0":
            annotationView.image = UIImage(named: "sesac_face_1")
        case "1":
            annotationView.image = UIImage(named: "sesac_face_2")
        case "2":
            annotationView.image = UIImage(named: "sesac_face_3")
        case "3":
            annotationView.image = UIImage(named: "sesac_face_4")
        case "4":
            annotationView.image = UIImage(named: "sesac_face_5")
        default :
            break
        }

        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //현재 보고 있는 지도의 중심을 찾음
        let center = mapView.centerCoordinate
        //print(center)
        nowLocation[0] = center.latitude
        nowLocation[1] = center.longitude

        self.searchFriends()
    }
    

}

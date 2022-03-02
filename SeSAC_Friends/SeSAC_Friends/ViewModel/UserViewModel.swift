//
//  AuthorizationViewModel.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/24.
//

import Foundation

import FirebaseAuth
import FirebaseMessaging

final class UserViewModel {
    //firebase에 phoneNumber로 인증 메세지 요청
    func authRequest(phoneNumber: String, completion: @escaping (Error?) -> Void)  {
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    completion(error)
                } else {
                    UserDefaults.standard.set(verificationID, forKey: UserdefaultKey.authVerificationID.rawValue)
                    completion(error)
                }
          }
    }
    
    //입력된 인증번호가 일치하는지 확인
    func authSignIn(inputCode: String, completion: @escaping (Error?) -> Void) {
        
        let verificationID = UserDefaults.standard.string(forKey: UserdefaultKey.authVerificationID.rawValue) ?? ""
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: inputCode)
        
        Auth.auth().signIn(with: credential) { success, error in
            if error == nil {
                print("인증 성공!!Id token 요청하기")
                completion(error)
            } else {
                completion(error)
            }
        }
    }
    
    //firebase id token (갱신)요청
    func idTokenRequest(completion: @escaping (Error?) -> Void) {
        
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            if let error = error {
                print("에러 발생")
                completion(error)
            }
            
            if let idToken = idToken {
                print("idtoken")
                print(idToken)
                UserDefaults.standard.set(idToken, forKey: UserdefaultKey.idToken.rawValue)
            }
            
            completion(error)
        }
    }
    
    //user 정보 요청
    func getUser(completion: @escaping (APIResult?, GetUserResult?, UserInfo?) -> Void) {
        
        let url = URL(string: "\(URL.user)")!
        let idtoken = UserDefaults.standard.string(forKey: UserdefaultKey.idToken.rawValue) ?? ""
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue(APIHeaderValue.ContentType.string, forHTTPHeaderField: APIHeader.ContentType.string)
        request.setValue("\(idtoken)", forHTTPHeaderField: APIHeader.idtoken.string)
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            print("getUser 결과")

            if error != nil {
                completion(.failed, nil, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.invalidResponse, nil, nil)
                return
            }
            
            guard let data = data else {
                completion(.noData, nil, nil)
                return
            }

            //상태코드에 따른 분기처리
            //200: 기존회원, 406: 미가입회원
            if response.statusCode == 200 {
                
                do {
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(UserInfo.self, from: data)
//                    case idToken
//                    case phoneNumber
                    UserDefaults.standard.set(userData.phoneNumber ,forKey: UserdefaultKey.phoneNumber.rawValue)
//                    case nickname
                    UserDefaults.standard.set(userData.nick, forKey: UserdefaultKey.nickname.rawValue)
//                    case gender
                    UserDefaults.standard.set(userData.gender ,forKey: UserdefaultKey.gender.rawValue)
//                    case birthDay
//                    case email
                    UserDefaults.standard.set(userData.email ,forKey: UserdefaultKey.email.rawValue)
//                    case matchingState
//                    case uid
                    UserDefaults.standard.set(userData.uid, forKey: UserdefaultKey.uid.rawValue)
//                    case genderFilter
//                    case shopCharacter
                    UserDefaults.standard.set(userData.sesac, forKey: UserdefaultKey.shopCharacter.rawValue)
//                    case shopBackground
                    UserDefaults.standard.set(userData.background, forKey: UserdefaultKey.shopBackground.rawValue)
//                    case sesacCollection
                    UserDefaults.standard.set(userData.sesacCollection, forKey: UserdefaultKey.sesacCollection.rawValue)
//                    case backgroundCollection
                    UserDefaults.standard.set(userData.backgroundCollection, forKey: UserdefaultKey.backgroundCollection.rawValue)
                    
                    //fcm token 갱신 필요 어부 판단
                    if let fcm = UserDefaults.standard.string(forKey: UserdefaultKey.fcmToken.rawValue) {
                        print("fcm 업데이트")
                        print(fcm)
                        print(userData.fcMtoken)
                        if fcm != userData.fcMtoken {
                            self.fcmTokenUpdate { apiResult, fcmUpdateResult in
                                print("fcmTokenUpdate")
                                print(fcmUpdateResult)
                            }
                        } else {
                            print("업데이트 필요 없음")
                        }
                    }

                    completion(.succeed, .existingUser, userData)
                } catch {
                    completion(.invalidData, nil, nil)
                }
            } else if response.statusCode == 406 {
                completion(.succeed, .newUser, nil)
            } else if response.statusCode == 401 {
                self.idTokenRequest { error in
                    completion(.failed, .tokenError, nil)
                }
            } else if response.statusCode == 500 {
                completion(.failed, .serverError, nil)
            } else if response.statusCode == 501 {
                completion(.failed, .clientError, nil)
            } else {
                completion(.failed, nil, nil)
            }

        }.resume()
        
    }
    
    //fcm token 갱신
    func fcmTokenUpdate(completion: @escaping (APIResult?, FCMUpdateResult?) -> Void) {

        let url = URL(string: "\(URL.userUpdateFCM)")!
        let idtoken = UserDefaults.standard.string(forKey: UserdefaultKey.idToken.rawValue) ?? ""
        let fcmtoken = UserDefaults.standard.string(forKey: UserdefaultKey.fcmToken.rawValue) ?? ""

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = "FCMtoken=\(fcmtoken)".data(using: .utf8, allowLossyConversion: false)
        request.setValue(APIHeaderValue.ContentType.string, forHTTPHeaderField: APIHeader.ContentType.string)
        request.setValue("\(idtoken)", forHTTPHeaderField: APIHeader.idtoken.string)

        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in

            if error != nil {
                completion(.failed, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.invalidResponse, nil)
                return
            }
            
            guard let data = data else {
                completion(.noData, nil)
                return
            }

            if response.statusCode == 200 {
                //fcm update 성공
                completion(.succeed, .succeed)
            } else if response.statusCode == 401 {
                //firebase token error
                self.idTokenRequest { error in
                    completion(.failed, .tokenError)
                }
            } else if response.statusCode == 406 {
                //not user
                completion(.failed, .notUser)
            } else if response.statusCode == 500 {
                //server error
                completion(.failed, .serverError)
            } else if response.statusCode == 501 {
                //client error
                completion(.failed, .clientError)
            } else {
                //not defined error
                completion(.failed, nil)
            }
        }.resume()
    }
    
    //회원가입
    func signIn(completion: @escaping (APIResult?, SignInResult?) -> Void) {
        
        let url = URL(string: "\(URL.user)")!
        let idtoken = UserDefaults.standard.string(forKey: UserdefaultKey.idToken.rawValue) ?? ""
        
        //httpBody
        let phoneNumber = UserDefaults.standard.string(forKey: UserdefaultKey.phoneNumber.rawValue) ?? ""
        let FCMtoken = UserDefaults.standard.string(forKey: UserdefaultKey.fcmToken.rawValue) ?? ""
        let nick = UserDefaults.standard.string(forKey: UserdefaultKey.nickname.rawValue) ?? ""
        let birth = UserDefaults.standard.string(forKey: UserdefaultKey.birthDay.rawValue) ?? ""
        let email = UserDefaults.standard.string(forKey: UserdefaultKey.email.rawValue) ?? ""
        let gender = UserDefaults.standard.integer(forKey: UserdefaultKey.gender.rawValue)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "phoneNumber=\(phoneNumber)&FCMtoken=\(FCMtoken)&nick=\(nick)&birth=\(birth)&email=\(email)&gender=\(gender)".data(using: .utf8, allowLossyConversion: false)
        request.setValue(APIHeaderValue.ContentType.string, forHTTPHeaderField: APIHeader.ContentType.string)
        request.setValue("\(idtoken)", forHTTPHeaderField: APIHeader.idtoken.string)
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failed, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.invalidResponse, nil)
                return
            }
            
            guard let data = data else {
                completion(.noData, nil)
                return
            }
            
            if response.statusCode == 200 {
                //회원가입 성공
                completion(.succeed, .succeed)
            } else if response.statusCode == 201 {
                //이미 가입한 유저
                completion(.succeed, .alreadyProcessed)
            } else if response.statusCode == 202 {
                //사용할 수 없는 닉네임
                completion(.succeed, .invalidNickname)
            } else if response.statusCode == 401 {
                //firebase token error
                self.idTokenRequest { error in
                    completion(.failed, .tokenError)
                }
            } else if response.statusCode == 406 {
                //not user
                completion(.failed, .notUser)
            } else if response.statusCode == 500 {
                //server error
                completion(.failed, .serverError)
            } else if response.statusCode == 501 {
                //client error
                completion(.failed, .clientError)
            } else {
                //not defined error
                completion(.failed, nil)
            }
            
        }.resume()
        
    }
    
    //회원탈퇴
    func userWithdraw(completion: @escaping (APIResult?, UserWithdrawResult?) -> Void) {
        
        let url = URL(string: "\(URL.userWithdraw)")!
        let idtoken = UserDefaults.standard.string(forKey: UserdefaultKey.idToken.rawValue) ?? ""
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue(APIHeaderValue.ContentType.string, forHTTPHeaderField: APIHeader.ContentType.string)
        request.setValue("\(idtoken)", forHTTPHeaderField: APIHeader.idtoken.string)
        
        let session = URLSession.shared

        session.dataTask(with: request) { data, response, error in
            print("userwithdraw 결과")

            if error != nil {
                completion(.failed, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.invalidResponse, nil)
                return
            }

            guard let data = data else {
                completion(.noData, nil)
                return
            }
            
            if response.statusCode == 200 {
                completion(.succeed, .succeed)
            } else if response.statusCode == 401 {
                self.idTokenRequest { error in
                    completion(.failed, .tokenError)
                }
            } else if response.statusCode == 406 {
                completion(.failed, .alreadyProcessed)
            } else if response.statusCode == 500 {
                completion(.failed, .serverError)
            } else if response.statusCode == 501 {
                completion(.failed, .clientError)
            } else {
                completion(.failed, nil)
            }
            
        }.resume()
        
    }
    
    func userInfoUpdate(searchable: Int, ageMin: Int, ageMax: Int, gender: Int, hobby: String, completion: @escaping (APIResult?, UserInfoUpdateResult?) -> Void) {
        
        let url = URL(string: "\(URL.userInfoUpdate)")!
        let idtoken = UserDefaults.standard.string(forKey: UserdefaultKey.idToken.rawValue) ?? ""
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = "searchable=\(searchable)&ageMin=\(ageMin)&ageMax=\(ageMax)&gender=\(gender)&hobby=\(hobby)".data(using: .utf8, allowLossyConversion: false)
        request.setValue(APIHeaderValue.ContentType.string, forHTTPHeaderField: APIHeader.ContentType.string)
        request.setValue("\(idtoken)", forHTTPHeaderField: APIHeader.idtoken.string)
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failed, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.invalidResponse, nil)
                return
            }

            guard let data = data else {
                completion(.noData, nil)
                return
            }
            
            if response.statusCode == 200 {
                completion(.succeed, .succeed)
            } else if response.statusCode == 401 {
                self.idTokenRequest { error in
                    completion(.failed, .tokenError)
                }
            } else if response.statusCode == 500 {
                completion(.failed, .serverError)
            } else if response.statusCode == 501 {
                completion(.failed, .clientError)
            } else {
                completion(.failed, nil)
            }
            
            
        }.resume()
    }

    //새싹친구 신고하기
    func userReport(otherUid: String, report: [Int], comment: String, completion: @escaping (APIResult?, UserReportResult?) -> Void) {
        let idtoken = UserDefaults.standard.string(forKey: UserdefaultKey.idToken.rawValue) ?? ""
        let url = URL(string: "\(URL.userReport)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = "otheruid=\(otherUid)&report=\(report)&comment=\(comment)".data(using: .utf8, allowLossyConversion: false)
        request.setValue(APIHeaderValue.ContentType.string, forHTTPHeaderField: APIHeader.ContentType.string)
        request.setValue("\(idtoken)", forHTTPHeaderField: APIHeader.idtoken.string)
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failed, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.invalidResponse, nil)
                return
            }
            
            guard let data = data else {
                completion(.noData, nil)
                return
            }
            
            if response.statusCode == 200 {
                completion(.succeed, .succeed)
            } else if response.statusCode == 401 {
                self.idTokenRequest { error in
                    completion(.succeed, .tokenError)
                }
            } else if response.statusCode == 500 {
                completion(.succeed, .serverError)
            } else if response.statusCode == 501 {
                completion(.succeed, .clientError)
            } else {
                completion(.failed, nil)
            }
        }.resume()
    }
    
    //새싹 캐릭터 정보 업데이트
    func userUpdateShop(character: Int, background: Int, completion: @escaping (APIResult?, UserUpdateShop?) -> Void) {
        
        let url = URL(string: "\(URL.userUpdateShop)")!
        let idtoken = UserDefaults.standard.string(forKey: UserdefaultKey.idToken.rawValue) ?? ""
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = "sesac=\(character)&background=\(background)".data(using: .utf8, allowLossyConversion: false)
        request.setValue(APIHeaderValue.ContentType.string, forHTTPHeaderField: APIHeader.ContentType.string)
        request.setValue("\(idtoken)", forHTTPHeaderField: APIHeader.idtoken.string)
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failed, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.invalidResponse, nil)
                return
            }

            guard let data = data else {
                completion(.noData, nil)
                return
            }
            
            if response.statusCode == 200 {
                completion(.succeed, .succeed)
            } else if response.statusCode == 201 {
                completion(.failed, .notPurchsed)
            } else if response.statusCode == 401 {
                self.idTokenRequest { error in
                    completion(.failed, .tokenError)
                }
            } else if response.statusCode == 500 {
                completion(.failed, .serverError)
            } else if response.statusCode == 501 {
                completion(.failed, .clientError)
            } else {
                completion(.failed, nil)
            }
            
            
        }.resume()
    }

    //새싹샵 아이템 구매
    func userShopPurchase(character: Int?, background: Int?, completion: @escaping (APIResult?, UserShopPurchase?) -> Void) {
        
        let url = URL(string: "\(URL.userShopPurchase)")!
        let idtoken = UserDefaults.standard.string(forKey: UserdefaultKey.idToken.rawValue) ?? ""
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        if let character = character {
            request.httpBody = "sesac=\(character)".data(using: .utf8, allowLossyConversion: false)
        }
        
        if let background = background {
            request.httpBody = "background=\(background)".data(using: .utf8, allowLossyConversion: false)
        }
        
        request.setValue(APIHeaderValue.ContentType.string, forHTTPHeaderField: APIHeader.ContentType.string)
        request.setValue("\(idtoken)", forHTTPHeaderField: APIHeader.idtoken.string)
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failed, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.invalidResponse, nil)
                return
            }

            guard let data = data else {
                completion(.noData, nil)
                return
            }
            
            if response.statusCode == 200 {
                completion(.succeed, .succeed)
            } else if response.statusCode == 201 {
                completion(.failed, .purchased)
            } else if response.statusCode == 401 {
                self.idTokenRequest { error in
                    completion(.failed, .tokenError)
                }
            } else if response.statusCode == 500 {
                completion(.failed, .serverError)
            } else if response.statusCode == 501 {
                completion(.failed, .clientError)
            } else {
                completion(.failed, nil)
            }
            
            
        }.resume()
    }

}

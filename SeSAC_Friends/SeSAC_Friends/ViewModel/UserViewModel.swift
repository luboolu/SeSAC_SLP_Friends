//
//  AuthorizationViewModel.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/24.
//

import Foundation

import FirebaseAuth
import FirebaseMessaging

class UserViewModel {
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
            //200: 기존회원, 201: 미가입회원
            if response.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(UserInfo.self, from: data)
                    print(userData)
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
    
    //회원가입
    func signIn(completion: @escaping (Int?) -> Void) {
        
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
                print(error)
                completion(-1)
            }

            guard let response = response as? HTTPURLResponse else {
                completion(-1)
                return
            }

            if let data = data {
                print(data)
            }
            
            if response.statusCode == 200 {
                //회원가입 성공
            } else if response.statusCode == 201 {
                //이미 가입한 유저
            } else if response.statusCode == 202 {
                //사용할 수 없는 닉네임
            } else if response.statusCode == 401 {
                //firebase token error
            } else if response.statusCode == 500 {
                //server error
            } else if response.statusCode == 501 {
                //client error
            } else {
                //not defined error
            }
            
            completion(response.statusCode)
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
                //여기서 idtoken 업데이트를 해야하나?
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

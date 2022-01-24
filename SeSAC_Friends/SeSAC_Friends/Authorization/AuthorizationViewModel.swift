//
//  AuthorizationViewModel.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/24.
//

import Foundation

import FirebaseAuth
import FirebaseMessaging

// MARK: - UserSignIn
struct UserSignIn: Codable {
    let phoneNumber, fcMtoken, nick, birth: String
    let email: String
    let gender: Int

    enum CodingKeys: String, CodingKey {
        case phoneNumber
        case fcMtoken = "FCMtoken"
        case nick, birth, email, gender
    }
}

class AuthorizationViewModel {
    
    //firebase에 phoneNumber로 인증 메세지 요청
    func authRequest(phoneNumber: String, completion: @escaping (Error?) -> Void)  {
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    print(error)
                    completion(error)
                } else {
                    print("authCode: \(verificationID)")
                    UserDefaults.standard.set(verificationID, forKey: UserdefaultKey.authVerificationID.string)
                    completion(error)
                }
          }
    }
    
    //입력된 인증번호가 일치하는지 확인
    func authSignIn(inputCode: String, completion: @escaping (Error?) -> Void) {
        
        let verificationID = UserDefaults.standard.string(forKey: UserdefaultKey.authVerificationID.string) ?? ""
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: inputCode)
        
        Auth.auth().signIn(with: credential) { success, error in
            if error == nil {
                print(success ?? "")
                print("인증 성공!!Id token 요청하기")
                completion(error)
            } else {
                completion(error)
            }
        }
    }
    
    func idTokenRequest(completion: @escaping (Error?) -> Void) {
        //firebase id token 요청
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            if let error = error {
                print("에러 발생")
                completion(error)
            }
            
            if let idToken = idToken {
                print(idToken)
                UserDefaults.standard.set(idToken, forKey: UserdefaultKey.idToken.string)
            }
            
            completion(error)
        }
    }
    
    func getUser(completion: @escaping (Int?) -> Void) {
        
        let url = URL(string: "\(URL.user)")!
        let idtoken = UserDefaults.standard.string(forKey: UserdefaultKey.idToken.string) ?? ""
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(idtoken)", forHTTPHeaderField: "idtoken")
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, response, error in
            print("getUser 결과")

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
            
            completion(response.statusCode)

        }.resume()
        
    }
    
    func signIn(completion: @escaping (Int?) -> Void) {
        
        let url = URL(string: "\(URL.user)")!
        let idtoken = UserDefaults.standard.string(forKey: UserdefaultKey.idToken.string) ?? ""
        var request = URLRequest(url: url)
        
        //httpBody
        let phoneNumber = UserDefaults.standard.string(forKey: UserdefaultKey.phoneNumber.string) ?? ""
        let fcmToken = UserDefaults.standard.string(forKey: UserdefaultKey.fcmToken.string) ?? ""
        let nick = UserDefaults.standard.string(forKey: UserdefaultKey.nickname.string) ?? ""
        let birth = UserDefaults.standard.string(forKey: UserdefaultKey.birthDay.string) ?? ""
        let email = UserDefaults.standard.string(forKey: UserdefaultKey.email.string) ?? ""
        let gender = UserDefaults.standard.integer(forKey: UserdefaultKey.gender.string)
        
        let body = UserSignIn(phoneNumber: phoneNumber, fcMtoken: fcmToken, nick: nick, birth: birth, email: email, gender: gender)
        guard let uploadBody = try? JSONEncoder().encode(body) else { return }
        
        print(idtoken)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(idtoken)", forHTTPHeaderField: "idtoken")
        
        let session = URLSession.shared
        
        session.uploadTask(with: request, from: uploadBody) { data, response, error in
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
            
            
            
            completion(-1)
        }.resume()
        
    }

}

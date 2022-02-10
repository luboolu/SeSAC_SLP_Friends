//
//  QueueViewModel.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/07.
//

import Foundation

final class QueueViewModel {
    private let userViewModel = UserViewModel()
    
    //새싹 친구 찾기 시작
    func queueStart(gender: Int, region: Int, lat: Double, long: Double, hobby: String ,completion: @escaping (APIResult?, QueueStart?) -> Void) {
        
        let url = URL(string: "\(URL.queue)")!
        let idtoken = UserDefaults.standard.string(forKey: UserdefaultKey.idToken.rawValue) ?? ""
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = "type=\(gender)&region=\(region)&lat=\(lat)&long=\(long)&hf=\(hobby)".data(using: .utf8, allowLossyConversion: false)
        request.setValue(APIHeaderValue.ContentType.string, forHTTPHeaderField: APIHeader.ContentType.string)
        request.setValue("\(idtoken)", forHTTPHeaderField: APIHeader.idtoken.string)
        print(request)
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
                completion(.succeed, .blocked)
            } else if response.statusCode == 203 {
                completion(.succeed, .penaltyLv1)
            } else if response.statusCode == 204 {
                completion(.succeed, .penaltyLv2)
            } else if response.statusCode == 205 {
                completion(.succeed, .penaltyLv3)
            } else if response.statusCode == 206 {
                completion(.succeed, .invalidGender)
            } else if response.statusCode == 401 {
                self.userViewModel.idTokenRequest { error in
                    completion(.succeed, .tokenError)
                }
            } else if response.statusCode == 406 {
                completion(.succeed, .notUser)
            } else if response.statusCode == 500 {
                completion(.succeed, .serverError)
            } else if response.statusCode == 501 {
                completion(.succeed, .clientError)
            } else {
                completion(.failed, nil)
            }
        }.resume()
    }
    
    //새싹 친구 찾기 중단
    func queueEnd(completion: @escaping (APIResult?, QueueStop?) -> Void) {
        
        let url = URL(string: "\(URL.queue)")!
        let idtoken = UserDefaults.standard.string(forKey: UserdefaultKey.idToken.rawValue) ?? ""
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
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
                completion(.succeed, .matched)
            } else if response.statusCode == 401 {
                self.userViewModel.idTokenRequest { error in
                    completion(.succeed, .tokenError)
                }
            } else if response.statusCode == 406 {
                completion(.succeed, .notUser)
            } else if response.statusCode == 500 {
                completion(.succeed, .serverError)
            } else if response.statusCode == 501 {
                completion(.succeed, .clientError)
            } else {
                completion(.failed, nil)
            }
        }.resume()
    }
    
    //새싹 친구 검색
    func queueOn(region: Int, lat: Double, long: Double, completion: @escaping (APIResult?, QueueOn?, QueueOnData?) -> Void) {
        
        let url = URL(string: "\(URL.queueOn)")!
        let idtoken = UserDefaults.standard.string(forKey: UserdefaultKey.idToken.rawValue) ?? ""
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue(APIHeaderValue.ContentType.string, forHTTPHeaderField: APIHeader.ContentType.string)
        request.httpBody = "region=\(region)&lat=\(lat)&long=\(long)".data(using: .utf8, allowLossyConversion: false)
        request.setValue("\(idtoken)", forHTTPHeaderField: APIHeader.idtoken.string)
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in

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
            
            if response.statusCode == 200 {

                do {
                    let decoder = JSONDecoder()
                    let queueOnData = try decoder.decode(QueueOnData.self, from: data)
                    
                    completion(.succeed, .succeed, queueOnData)
                } catch {
                    completion(.invalidData, nil, nil)
                }
                
                
            } else if response.statusCode == 401 {
                self.userViewModel.idTokenRequest { error in
                    completion(.succeed, .tokenError, nil)
                }
            } else if response.statusCode == 406 {
                completion(.succeed, .notUser, nil)
            } else if response.statusCode == 500 {
                completion(.succeed, .serverError, nil)
            } else if response.statusCode == 501 {
                completion(.succeed, .clientError, nil)
            } else {
                completion(.failed, nil, nil)
            }
        }.resume()
    }

}

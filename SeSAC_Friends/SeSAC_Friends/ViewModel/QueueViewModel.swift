//
//  QueueViewModel.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/07.
//

import Foundation

final class QueueViewModel {
    private let userViewModel = UserViewModel()
    
    //user 정보 요청
    func queueStart(gender: Int, region: Int, lat: Double, long: Double, hobby: [String] ,completion: @escaping (APIResult?, QueueStart?) -> Void) {
        
        let url = URL(string: "\(URL.queue)")!
        let idtoken = UserDefaults.standard.string(forKey: UserdefaultKey.idToken.rawValue) ?? ""
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = "gender=\(gender)&region=\(region)&lat=\(lat)&long=\(long)&hobby=\(hobby)".data(using: .utf8, allowLossyConversion: false)
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
                completion(.succeed, .blocked)
            }  else if response.statusCode == 203 {
                completion(.succeed, .penaltyLv1)
            }  else if response.statusCode == 204 {
                completion(.succeed, .penaltyLv2)
            }  else if response.statusCode == 205 {
                completion(.succeed, .penaltyLv3)
            }  else if response.statusCode == 206 {
                completion(.succeed, .invalidGender)
            }  else if response.statusCode == 401 {
                self.userViewModel.idTokenRequest { error in
                    completion(.succeed, .tokenError)
                }
            }  else if response.statusCode == 406 {
                completion(.succeed, .notUser)
            }  else if response.statusCode == 500 {
                completion(.succeed, .serverError)
            }  else if response.statusCode == 501 {
                completion(.succeed, .clientError)
            } else {
                completion(.failed, nil)
            }
        }.resume()
    }

}

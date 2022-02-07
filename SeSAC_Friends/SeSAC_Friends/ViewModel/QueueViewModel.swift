//
//  QueueViewModel.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/07.
//

import Foundation

//user 정보 요청
func queueStart(gender: Int, region: Int, lat: Double, long: Double, hobby: [String] ,completion: @escaping (APIResult?) -> Void) {
    
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
            completion(.failed)
            return
        }
        
        guard let response = response as? HTTPURLResponse else {
            completion(.invalidResponse)
            return
        }
        
        guard let data = data else {
            completion(.noData)
            return
        }
        
        if response.statusCode == 200 {
            completion(.succeed)
        } else {
            completion(.failed)
        }
    }.resume()
}

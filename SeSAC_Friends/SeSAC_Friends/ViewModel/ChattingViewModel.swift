//
//  ChattingViewModel.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/21.
//

import Foundation

final class ChattingViewModel {
    
    private let userViewModel = UserViewModel()
    
    func getChattingData(uid: String, lastChatDate: String, completion: @escaping (APIResult?, GetChat? ,GetChatData?) -> Void) {
        
        let url = URL(string: "\(URL.chat)/\(uid)?lastchatDate=\(lastChatDate)")!
        let idtoken = UserDefaults.standard.string(forKey: UserdefaultKey.idToken.rawValue) ?? ""
        //let hfBody = try? JSONSerialization.data(withJSONObject: hobby)
        var request = URLRequest(url: url)
        //print(hfBody)
        request.httpMethod = "GET"
        //request.httpBody = "uid=\(uid)&lastChatDate=\(lastChatDate)".data(using: .utf8, allowLossyConversion: false)
        request.addValue(APIHeaderValue.ContentType.string, forHTTPHeaderField: APIHeader.ContentType.string)
        request.addValue("\(idtoken)", forHTTPHeaderField: APIHeader.idtoken.string)
        
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
                    let chatData = try decoder.decode(GetChatData.self, from: data)
                    
                    completion(.succeed, .succeed, chatData)
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
    
    func postChat(uid: String, message: String, completion: @escaping (APIResult?, PostChat?, Payload?) -> Void) {
        
        let url = URL(string: "\(URL.chat)/\(uid)")!
        let idtoken = UserDefaults.standard.string(forKey: UserdefaultKey.idToken.rawValue) ?? ""

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "chat=\(message)".data(using: .utf8, allowLossyConversion: false)
        request.addValue(APIHeaderValue.ContentType.string, forHTTPHeaderField: APIHeader.ContentType.string)
        request.addValue("\(idtoken)", forHTTPHeaderField: APIHeader.idtoken.string)
        
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
                    let chatData = try decoder.decode(Payload.self, from: data)
                    completion(.succeed, .succeed, chatData)
                } catch {
                    completion(.invalidData, nil, nil)
                }
            } else if response.statusCode == 201 {
                completion(.succeed, .notMatched, nil)
            }  else if response.statusCode == 401 {
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

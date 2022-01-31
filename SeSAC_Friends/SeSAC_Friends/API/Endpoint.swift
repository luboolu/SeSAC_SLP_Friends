//
//  Endpoint.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/24.
//

import Foundation

extension URL {
    
    static let baseURL = "http://test.monocoding.com:35484"
    
    static func makeEndPoint(_ endpoint: String) -> URL {
        URL(string: baseURL + endpoint)!
    }
    
    static var user: URL {
        return makeEndPoint("/user")
    }
    
    static var userWithdraw: URL {
        return URL(string: "\(URL.user)/withdraw")!
    }
    
    static var userUpdateFCM: URL {
        return URL(string: "\(URL.user)/update_fcm_token")!
    }
    
}

enum APIHeader {
    
    case ContentType
    case idtoken
    
    var string: String {
        switch self {
        case .ContentType:
            return "Content-Type"
        case .idtoken:
            return "idtoken"
        }
    }
    
}

enum APIHeaderValue {
    
    case ContentType
    
    var string: String {
        switch self {
        case .ContentType:
            return "application/x-www-form-urlencoded"
        }
    }
}



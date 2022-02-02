//
//  APIenum.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/01.
//

import Foundation


enum APIResult: Error {
    case invalidResponse
    case noData
    case failed
    case invalidData
    case succeed
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

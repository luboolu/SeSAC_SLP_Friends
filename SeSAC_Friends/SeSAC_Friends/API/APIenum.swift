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
    case succeed //200 ~ 299
    case tokenError //401
    case processed //406
    case serverError //500
    case clientError //501
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

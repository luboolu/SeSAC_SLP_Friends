//
//  UserdefualtKey.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/24.
//

import Foundation

enum UserdefaultKey {
    case authVerificationID
    case fcmToken
    case idToken
    case phoneNumber
    case nickname
    case gender
    case birthDay
    case email
    
    var string: String {
        switch self {
        case .authVerificationID:
            return "authVerificationID"
        case .fcmToken:
            return "fcmToken"
        case .idToken:
            return "idToken"
        case .phoneNumber:
            return "phoneNumber"
        case .nickname:
            return "nickname"
        case .gender:
            return "gender"
        case .birthDay:
            return "birthDay"
        case .email:
            return "email"
        }
    }
    

}

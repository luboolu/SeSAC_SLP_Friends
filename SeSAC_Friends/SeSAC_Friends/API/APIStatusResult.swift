//
//  APIStatusResult.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/02.
//

import Foundation

enum GetUserResult {
    case existingUser //200
    case newUser      //201
    case tokenError   //401
    case serverError  //500
    case clientError  //501
}

enum SignInResult {
    case tokenError   //401
    case serverError  //500
    case clientError  //501
}

enum UserWithdrawResult {
    case succeed      //200
    case alreadyProcessed //406
    case tokenError   //401
    case serverError  //500
    case clientError  //501
}

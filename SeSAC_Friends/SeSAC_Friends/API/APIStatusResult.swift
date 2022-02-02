//
//  APIStatusResult.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/02.
//

import Foundation

//유저 정보 요청
enum GetUserResult {
    case existingUser //200
    case newUser      //201
    case tokenError   //401
    case serverError  //500
    case clientError  //501
}

//회원가입
enum SignInResult {
    case tokenError   //401
    case serverError  //500
    case clientError  //501
}

//회원탈퇴
enum UserWithdrawResult {
    case succeed      //200
    case alreadyProcessed //406
    case tokenError   //401
    case serverError  //500
    case clientError  //501
}

//유저 정보 업데이트(정보관리)
enum UserInfoUpdateResult {
    case succeed      //200
    case tokenError   //401
    case serverError  //500
    case clientError  //501
}

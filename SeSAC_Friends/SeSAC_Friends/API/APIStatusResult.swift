//
//  APIStatusResult.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/02.
//

import Foundation

//MARK: UserViewModel
//유저 정보 요청
enum GetUserResult {
    case existingUser //200
    case tokenError   //401
    case newUser      //201
    case serverError  //500
    case clientError  //501
}

//회원가입
enum SignInResult {
    case succeed          //200
    case alreadyProcessed //201
    case invalidNickname  //202
    case tokenError       //401
    case notUser          //406
    case serverError      //500
    case clientError      //501
}

//회원탈퇴
enum UserWithdrawResult {
    case succeed      //200
    case tokenError   //401
    case alreadyProcessed //406
    case serverError  //500
    case clientError  //501
}

//유저 정보 업데이트(정보관리)
enum UserInfoUpdateResult {
    case succeed      //200
    case tokenError   //401
    case notUser      //406
    case serverError  //500
    case clientError  //501
}

//MARK: QueueViewModel
//친구 찾기 요청 시작
enum QueueStart {
    case succeed       //200
    case blocked       //201
    case penaltyLv1    //203
    case penaltyLv2    //204
    case penaltyLv3    //205
    case invalidGender //206
    case tokenError    //401
    case notUser       //406
    case serverError   //500
    case clientError   //501
}

//친구 찾기 요청 취소
enum QueueStop {
    case succeed      //200
    case matched      //201
    case tokenError   //401
    case notUser      //406
    case serverError  //500
    case clientError  //501
}

//친구 찾기 요청 취소
enum QueueOn {
    case succeed      //200
    case tokenError   //401
    case notUser      //406
    case serverError  //500
    case clientError  //501
}

//취미 함께하기 요청
enum QueueHobbyRequest {
    case succeed      //200
    case requested    //201
    case stopped      //202
    case tokenError   //401
    case notUser      //406
    case serverError  //500
    case clientError  //501
}

//취미 함께하기 수락
enum QueueHobbyAccept {
    case succeed      //200
    case otherMatched //201
    case stopped      //202
    case otherAccepted//203
    case tokenError   //401
    case notUser      //406
    case serverError  //500
    case clientError  //501
}

//내 매칭 상태 확인
enum QueueState {
    case succeed      //200
    case stopped      //201
    case tokenError   //401
    case notUser      //406
    case serverError  //500
    case clientError  //501
}

//새싹친구 리뷰 남기기
enum QueueRate {
    case succeed      //200
    case tokenError   //401
    case notUser      //406
    case serverError  //500
    case clientError  //501
}


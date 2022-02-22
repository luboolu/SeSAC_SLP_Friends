//
//  RealmModel.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/22.
//

import Foundation
import RealmSwift

//채팅 내역을 저장하기 위한 데이터베이스
//추후 to, from, createdAt으로 잘 filter 해야함
class UserChatting: Object {
    
    @Persisted var to: String       //채팅을 받는 사람의 uid
    @Persisted var from: String     //채팅을 보내는 사람의 uid
    @Persisted var chat: String     //보낸 채팅 내용
    @Persisted var createdAt: String  //채팅을 보낸 시간
    
    //PK
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(to: String, from: String, chat: String, createdAt: String) {
        self.init()
        
        self.to = to
        self.from = from
        self.chat = chat
        self.createdAt = createdAt
    }
    
}

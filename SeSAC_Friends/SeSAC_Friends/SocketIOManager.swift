//
//  SocketIOManager.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/23.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    
    let token = UserDefaults.standard.string(forKey: UserdefaultKey.idToken.rawValue) ?? ""
    let myUID = UserDefaults.standard.string(forKey: UserdefaultKey.uid.rawValue) ?? ""
    
    //서버와의 매세지리를 주고받기 위한 클래스
    var manager: SocketManager!
    
    //클라이언트 소켓
    var socket: SocketIOClient!
    
    override init() {
        super.init()
        
        let url = URL(string: "http://test.monocoding.com:35484/chat")!
        
        manager = SocketManager(socketURL: url, config: [
            .log(false),
            .compress,
            .extraHeaders(["idtoken": token])
            ])
        
        socket = manager.defaultSocket // "/"로 된 룸
        
        //소켓 연결 메서드
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket is connected", data, ack)
            print(self.myUID)
            self.socket.emit("changesocketid", self.myUID)
        }
        
        //소켓 연결 해제 메서드
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        
        
        //소켓 채팅 듣는 메서드, sesac 이벤트로 날아온 데이터를 수신
        //데이터 수신 -> 디코딩 -> 모델에 추가 -> 갱신
        socket.on("chat") { data, ack in
            //print("SESAC RECIEVE", data, ack)
            let data = data[0] as! NSDictionary
            let id = data["_id"] as! String
            let chat = data["chat"] as! String
            let createdAt = data["createdAt"] as! String
            let from = data["from"] as! String
            let to = data["to"] as! String
            //print("CHECK: ", data, id, chat, createdAt, from, to)
             
            NotificationCenter.default.post(name: NSNotification.Name("getMessage"), object: self, userInfo: ["_id": id, "chat": chat, "createdAt": createdAt, "from": from, "to": to])

        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}

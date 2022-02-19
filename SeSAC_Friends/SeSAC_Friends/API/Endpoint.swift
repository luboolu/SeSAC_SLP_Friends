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
    
    static var queue: URL {
        return makeEndPoint("/queue")
    }
    
    //MARK: User
    static var userWithdraw: URL {
        return URL(string: "\(URL.user)/withdraw")!
    }
    
    static var userInfoUpdate: URL {
        return URL(string: "\(URL.user)/update/mypage")!
    }
    
    static var userUpdateFCM: URL {
        return URL(string: "\(URL.user)/update_fcm_token")!
    }
    
    static var userReport: URL {
        return URL(string: "\(URL.user)/report")!
    }
    
    //MARK: Queue
    static var queueOn: URL {
        return URL(string: "\(URL.queue)/onqueue")!
    }
    
    static var queueRequest: URL {
        return URL(string: "\(URL.queue)/hobbyrequest")!
    }
    
    static var queueAcceept: URL {
        return URL(string: "\(URL.queue)/hobbyaccept")!
    }
    
    static var queueState: URL {
        return URL(string: "\(URL.queue)/myQueueState")!
    }
    
    static var queueRate: URL {
        return URL(string: "\(URL.queue)/rate")!
    }
    
    static var queueDodge: URL {
        return URL(string: "\(URL.queue)/dodge")!
    }
    
    
    
}



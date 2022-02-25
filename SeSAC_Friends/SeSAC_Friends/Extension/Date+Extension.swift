//
//  DateFormatter+Extension.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/22.
//

import Foundation

extension DateFormatter {
    
    static var isoFormat: ISO8601DateFormatter {
        let date = ISO8601DateFormatter()
        date.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                            
        return date
    }
    
    static var chattingTime: DateFormatter {
        let date = DateFormatter()
        date.dateFormat = "HH:mm"
        date.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        return date
    }
}

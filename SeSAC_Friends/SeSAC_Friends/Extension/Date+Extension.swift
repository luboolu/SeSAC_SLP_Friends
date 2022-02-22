//
//  DateFormatter+Extension.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/22.
//

import Foundation

extension DateFormatter {
    static var chattingTime: DateFormatter {
        let date = DateFormatter()
        date.dateFormat = "hh:mm"
        
        return date
    }
}

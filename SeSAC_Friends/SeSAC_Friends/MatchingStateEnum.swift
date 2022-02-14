//
//  MatchingStateEnum.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/14.
//

import Foundation
import AVFoundation

enum matchingState: String {
    case waiting //매칭 대기중 ( queueStart 된 상태)
    case matched //친구와 매칭된 상태
    case noState //상태 없음, queueStop되거나 queueStart를 하지 않은 상태
}

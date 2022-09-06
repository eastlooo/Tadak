//
//  TypingMode.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import Foundation

enum TypingMode {
    case practice, official, betting
    
    var description: String {
        switch self {
        case .practice: return "연습 모드"
        case .official: return "실전 모드"
        case .betting: return "내기 모드"
        }
    }
}

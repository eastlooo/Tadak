//
//  Abuse.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/28.
//

import Foundation

enum Abuse: String {
    
    case usingHardware
    case multipleInputs
    
    var alertMessage: String {
        switch self {
        case .usingHardware:
            return "하드웨어 키보드 연결이 감지됐어요\n\n공식모드에서는 소프트웨어\n키보드만 사용할 수 있어요!"
            
        case .multipleInputs:
            return "다중 입력이 감지됐어요\n서드파티 키보드 이용 시\n다중 입력을 확인 해주세요!"
        }
    }
}

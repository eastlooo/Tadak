//
//  Setting.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/29.
//

import UIKit

enum Setting {
    
    case profile(characterID: Int, nickname: String)
    case contact
    case clearAllData
    
    var title: String {
        switch self {
        case .profile(_, let nickname): return nickname
        case .contact: return "문의/피드백"
        case .clearAllData: return "데이터 모두 지우기"
        }
    }
    
    var subTitle: String? {
        switch self {
        case .profile: return "프로필 수정하기"
        case .contact: return nil
        case .clearAllData: return nil
        }
    }
    
    var image: UIImage? {
        switch self {
        case .profile(let id, _): return UIImage.character(id)
        case.contact: return nil
        case .clearAllData: return nil
        }
    }
}

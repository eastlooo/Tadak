//
//  UserEvent.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/27.
//

import Foundation

enum UserEvent: AnalyticsEvent {
    
    case register(nickname: String, characterID: Int)
    case delete
    
    var name: String {
        switch self {
        case .register: return "register_user_event"
        case .delete: return "delete_user_event"
        }
    }
    
    var parameters: AnalyticsEventParameters {
        switch self {
        case .register:
            return [:]
            
        case .delete:
            return [:]
        }
    }
    
    var userProperties: AnalyticsEventUserProperties {
        switch self {
        case .register(let nickname, let characterID):
            let character = AnimalCharacter(rawValue: characterID)
            return ["nickname": nickname, "character": character?.name]
            
        case .delete:
            return [:]
        }
    }
}

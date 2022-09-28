//
//  CompositionEvent.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/29.
//

import Foundation

enum CompositionEvent: AnalyticsEvent {
    
    case create(composition: MyComposition)
    case delete
    
    var name: String {
        switch self {
        case .create: return "create_mycomposition_event"
        case .delete: return "delete_mycomposition_event"
        }
    }
    
    var parameters: AnalyticsEventParameters {
        switch self {
        case .create(let composition):
            return [
                "title": composition.title,
                "artist": composition.artist,
                "contents": composition.contents
            ]
            
        case .delete:
            return [:]
        }
    }
    
    var userProperties: AnalyticsEventUserProperties { return [:] }
}

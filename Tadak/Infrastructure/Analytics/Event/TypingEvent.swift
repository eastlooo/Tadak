//
//  TypingEvent.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/28.
//

import Foundation

enum TypingEvent: AnalyticsEvent {
    
    case startTadakPractice(title: String, artist: String)
    case startTadakOfficial(title: String, artist: String)
    case startTadakBetting(title: String, artist: String, numOfParticipants: Int)
    case startMyPractice(title: String, artist: String)
    case startMyBetting(title: String, artist: String, numOfParticipants: Int)
    
    case resultTadakOfficial(record: Record)
    
    case abuse(abuse: Abuse)
    
    var name: String {
        switch self {
        case .startTadakPractice: return "start_tadak_practice_event"
        case .startTadakOfficial: return "start_tadak_official_event"
        case .startTadakBetting: return "start_tadak_betting_event"
        case .startMyPractice: return "start_my_practice_event"
        case .startMyBetting: return "start_my_betting_event"
        case .resultTadakOfficial: return "result_tadak_official_event"
        case .abuse: return "abuse_event"
        }
    }
    
    var parameters: AnalyticsEventParameters {
        switch self {
        case .startTadakPractice(let title, let artist):
            return ["title": title, "artist": artist]
            
        case .startTadakOfficial(let title, let artist):
            return ["title": title, "artist": artist]
            
        case .startTadakBetting(let title, let artist, let numOfParticipants):
            return ["title": title, "artist": artist, "numOfParticipants": numOfParticipants]
            
        case .startMyPractice(let title, let artist):
            return ["title": title, "artist": artist]
            
        case .startMyBetting(let title, let artist, let numOfParticipants):
            return ["title": title, "artist": artist, "numOfParticipants": numOfParticipants]
            
            
        case .resultTadakOfficial(let record):
            return ["id": record.compositionID, "score": record.typingSpeed]
            
        case .abuse(let abuse):
            return ["abuse": abuse.rawValue]
        }
    }
    
    var userProperties: AnalyticsEventUserProperties { return [:] }
}

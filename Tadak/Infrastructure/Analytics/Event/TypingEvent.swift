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
    
    case resultTadakPractice(title: String, record: Record)
    case resultTadakOfficial(title: String, record: Record)
    case resultTadakBetting(title: String, records: [Record])
    case resultMyPractice(title: String, record: Record)
    case resultMyBetting(title: String, records: [Record])
    
    case retry
    case share
    
    case abuse(abuse: Abuse)
    
    var name: String {
        switch self {
        case .startTadakPractice: return "start_tadak_practice_event"
        case .startTadakOfficial: return "start_tadak_official_event"
        case .startTadakBetting: return "start_tadak_betting_event"
        case .startMyPractice: return "start_my_practice_event"
        case .startMyBetting: return "start_my_betting_event"
        case .resultTadakPractice: return "result_tadak_practice_event"
        case .resultTadakOfficial: return "result_tadak_official_event"
        case .resultTadakBetting: return "result_tadak_betting_event"
        case .resultMyPractice: return "result_my_practice_event"
        case .resultMyBetting: return "result_my_betting_event"
        case .retry: return "typing_retry_event"
        case .share: return "share_event"
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
            
        case .resultTadakPractice(let title, let record):
            return [
                "title": title,
                "id": record.compositionID,
                "speed": record.typingSpeed,
                "accuracy": record.accuracy,
                "time": record.elapsedTime
            ]
            
        case .resultTadakOfficial(let title, let record):
            return [
                "title": title,
                "id": record.compositionID,
                "speed": record.typingSpeed,
                "accuracy": record.accuracy,
                "time": record.elapsedTime
            ]
            
        case .resultTadakBetting(let title, let records):
            var dictionary: AnalyticsEventParameters = ["title": title]
            dictionary["id"] = records.first?.compositionID
            
            for index in 0..<records.count {
                let record = records[index]
                dictionary["speed\(index+1)"] = record.typingSpeed
                dictionary["accuracy\(index+1)"] = record.accuracy
                dictionary["time\(index+1)"] = record.elapsedTime
            }
            
            return dictionary
            
        case .resultMyPractice(let title, let record):
            return [
                "title": title,
                "id": record.compositionID,
                "speed": record.typingSpeed,
                "accuracy": record.accuracy,
                "time": record.elapsedTime
            ]
            
        case .resultMyBetting(let title, let records):
            var dictionary: AnalyticsEventParameters = ["title": title]
            dictionary["id"] = records.first?.compositionID
            
            for index in 0..<records.count {
                let record = records[index]
                dictionary["speed\(index+1)"] = record.typingSpeed
                dictionary["accuracy\(index+1)"] = record.accuracy
                dictionary["time\(index+1)"] = record.elapsedTime
            }
            
            return dictionary
            
        case .retry, .share:
            return [:]
            
        case .abuse(let abuse):
            return ["abuse": abuse.rawValue]
        }
    }
    
    var userProperties: AnalyticsEventUserProperties { return [:] }
}

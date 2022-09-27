//
//  AnalyticsProvider.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/27.
//

import Foundation

protocol AnalyticsProvider {
    
    var name: String { get }
    
    func logEvent(_ event: AnalyticsEvent,
                  _ parameters: [String: Any],
                  _ userProperties: [String: String])
    func setUserID(_ userID: String?)
}

//
//  AnalyticsManager.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/27.
//

import Foundation

final class AnalyticsManager {
    
    private var providers: [AnalyticsProvider] = []
    
    private static let instance: AnalyticsManager = .init()
    
    private init() {}
    
    static func register(_ providers: [AnalyticsProvider]) {
        instance.providers += providers
    }
    
    static func log(_ event: AnalyticsEvent) {
        let parameters = event.parameters.reduce(into: [:]) { $0[$1.key] = $1.value }
        let userProperties = event.userProperties.reduce(into: [:]) { $0[$1.key] = $1.value }
        
        for provider in instance.providers {
            provider.logEvent(event, parameters, userProperties)
        }
    }
    
    static func setUserID(_ userID: String?) {
        for provider in instance.providers {
            provider.setUserID(userID)
        }
    }
}

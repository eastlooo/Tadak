//
//  FirebaseAnalyticsProvider.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/27.
//

import Foundation
import FirebaseAnalytics

final class FirebaseAnalyticsProvider: AnalyticsProvider {
    
    let name: String = "Firebase"
    
    func logEvent(_ event: AnalyticsEvent, _ parameters: [String : Any], _ userProperties: [String : String]) {
        
        for userProperty in userProperties {
            Analytics.setUserProperty(userProperty.value, forName: userProperty.key)
        }
        
        Analytics.logEvent(event.name, parameters: parameters)
    }
        
    
    func setUserID(_ userID: String?) {
        Analytics.setUserID(userID)
    }
}

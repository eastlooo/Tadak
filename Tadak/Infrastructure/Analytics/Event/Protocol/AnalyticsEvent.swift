//
//  AnalyticsEvent.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/27.
//

import Foundation

typealias AnalyticsEventParameters = [String: Any?]
typealias AnalyticsEventUserProperties = [String: String?]

protocol AnalyticsEvent {
    
    var name: String { get }
    var parameters: AnalyticsEventParameters { get }
    var userProperties: AnalyticsEventUserProperties { get }
}

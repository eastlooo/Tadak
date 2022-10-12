//
//  AppReviewManager.swift
//  Tadak
//
//  Created by 정동천 on 2022/10/12.
//

import UIKit
import StoreKit

enum AppReviewManager {
    
    private static let minimumWorthyActionCount: Int = 2
    
    private static var actionCountOnSession: Int = 0
    
    private static var sessionCount: Int {
        get { UserDefaults.standard.integer(forKey: "sessionCount") }
        set { UserDefaults.standard.set(newValue, forKey: "sessionCount") }
    }
    
    private static var requestedReviewCount: Int {
        get { UserDefaults.standard.integer(forKey: "requestedReviewCount") }
        set { UserDefaults.standard.set(newValue, forKey: "requestedReviewCount") }
    }
}

extension AppReviewManager {
    
    static func increaseSessionCount() {
        sessionCount += 1
    }
    
    static func increaseActionCount(_ value: Int = 1) {
        actionCountOnSession += value
    }
    
    static func requestReviewIfSatisfied() {
        print("DEBUG: sessionCount \(sessionCount)")
        print("DEBUG: requestedReviewCount \(requestedReviewCount)")
        
        guard sessionCount > requestedReviewCount * 3 + 1,
            actionCountOnSession >= minimumWorthyActionCount else { return }
        
        if let windowScene = UIWindow.keyWindow?.windowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

//
//  RealmConfigurationType.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/10.
//

import Foundation
import RealmSwift

enum RealmConfigurationType {
    case basic(url: String?)
    case inMemory(identifier: String?)
    
    var associated: String? {
        switch self {
        case .basic(let url):
            return url
            
        case .inMemory(let identifier):
            return identifier
        }
    }
}

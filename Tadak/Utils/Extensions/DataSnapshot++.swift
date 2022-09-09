//
//  DataSnapshot++.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/09.
//

import Foundation
import FirebaseDatabase

extension DataSnapshot {
    
    var valueToJSON: Data {
        guard let dictionary = value as? [String: Any] else { return Data() }
        return dictionary.json
    }
    
    var listToJSON: Data {
        guard let object = children.allObjects as? [DataSnapshot] else { return Data() }
        
        let dictionary: [NSDictionary] = object.compactMap { $0.value as? NSDictionary }
        
        do {
            return try JSONSerialization.data(
                withJSONObject: dictionary,
                options: .prettyPrinted
            )
        } catch { return Data() }
    }
}

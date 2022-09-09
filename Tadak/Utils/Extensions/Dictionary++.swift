//
//  Dictionary++.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/09.
//

import Foundation

extension Dictionary {
    
    var json: Data {
        do {
            return try JSONSerialization.data(
                withJSONObject: self,
                options: .prettyPrinted
            )
        } catch { return Data() }
    }
}

//
//  Composition.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/07.
//

import Foundation

struct Composition: Identifiable, Equatable {
    
    typealias Identifier = String
    
    let id: Identifier
    let title: String
    let artist: String
    let contents: String
    
    static func == (lhs: Composition, rhs: Composition) -> Bool {
        lhs.id == rhs.id
    }
}

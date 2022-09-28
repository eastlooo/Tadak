//
//  Composition.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/07.
//

import Foundation

protocol Composition: Identifiable, Equatable {
    
    typealias Identifier = String
    
    var id: Identifier { get }
    var title: String { get }
    var artist: String { get }
    var contents: String { get }
}

extension Composition {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

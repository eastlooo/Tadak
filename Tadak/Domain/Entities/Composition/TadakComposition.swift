//
//  TadakComposition.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/29.
//

import Foundation

struct TadakComposition: Composition {
    
    let id: Identifier
    let title: String
    let artist: String
    let contents: String
}

struct TadakCompositionPage {
    
    let version: String
    let compositions: [TadakComposition]
}

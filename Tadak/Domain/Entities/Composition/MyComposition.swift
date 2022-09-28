//
//  MyComposition.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/29.
//

import Foundation

struct MyComposition: Composition {
    
    let id: Identifier
    let title: String
    let artist: String
    let contents: String
}

struct MyCompositionPage {
    
    let compositions: [MyComposition]
}

//
//  TadakUser.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/07.
//

import Foundation

struct TadakUser: Identifiable, Equatable {
    typealias Identifier = String
    
    let id: Identifier
    let nickname: String
    let characterID: Int
}

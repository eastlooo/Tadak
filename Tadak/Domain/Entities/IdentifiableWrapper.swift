//
//  IdentifiableWrapper.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/16.
//

import Foundation

struct IdentifiableWrapper<T>: Equatable {
    
    let data: T
    private let id: UUID
    
    init(data: T) {
        self.data = data
        self.id = UUID()
    }
    
    static func == (lhs: IdentifiableWrapper, rhs: IdentifiableWrapper) -> Bool {
        lhs.id == rhs.id
    }
}

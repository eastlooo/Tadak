//
//  CompostionDTO.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import Foundation

struct CompositionResponseDTO: Decodable {
    
    let id: String
    let title: String
    let artist: String
    let contents: String
}

extension CompositionResponseDTO {
    
    func toDomain() -> Composition {
        return .init(
            id: self.id,
            title: self.title,
            artist: self.artist,
            contents: self.contents
        )
    }
}

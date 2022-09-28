//
//  CompostionDTO.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import Foundation

struct TadakCompositionResponseDTO: Decodable {
    
    let id: String
    let title: String
    let artist: String
    let contents: String
}

extension TadakCompositionResponseDTO {
    
    func toDomain() -> TadakComposition {
        return .init(
            id: self.id,
            title: self.title,
            artist: self.artist,
            contents: self.contents
        )
    }
}

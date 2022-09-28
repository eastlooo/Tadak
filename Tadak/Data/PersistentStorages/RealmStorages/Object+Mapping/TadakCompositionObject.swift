//
//  TadakCompositionObject.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/29.
//

import Foundation
import RealmSwift

final class TadakCompositionObject: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var artist: String
    @Persisted var contents: String
    
    convenience init(
        composition: TadakComposition
    ) {
        self.init()
        self.id = composition.id
        self.title = composition.title
        self.artist = composition.artist
        self.contents = composition.contents
    }
}

extension TadakCompositionObject {
    
    func toDomain() -> TadakComposition {
        return .init(
            id: self.id,
            title: self.title,
            artist: self.artist,
            contents: self.contents
        )
    }
}

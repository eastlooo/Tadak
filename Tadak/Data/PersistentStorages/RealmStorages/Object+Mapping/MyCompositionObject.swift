//
//  MyCompositionObject.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/29.
//

import Foundation
import RealmSwift

final class MyCompositionObject: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var artist: String
    @Persisted var contents: String
    
    convenience init(
        composition: MyComposition
    ) {
        self.init()
        self.id = composition.id
        self.title = composition.title
        self.artist = composition.artist
        self.contents = composition.contents
    }
}

extension MyCompositionObject {
    
    func toDomain() -> MyComposition {
        return .init(
            id: self.id,
            title: self.title,
            artist: self.artist,
            contents: self.contents
        )
    }
}

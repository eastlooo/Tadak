//
//  TadakCompositionPageObject.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import Foundation
import RealmSwift

final class TadakCompositionPageObject: Object {
    
    @Persisted(primaryKey: true) var version: String
    @Persisted var compositions = List<TadakCompositionObject>()
    
    convenience init(
        tadakComposition: TadakCompositionPage
    ) {
        self.init()
        
        let version = tadakComposition.version
        let compositions = tadakComposition.compositions
        let objects = compositions.map(TadakCompositionObject.init)
        self.version = version
        self.compositions.append(objectsIn: objects)
    }
}

extension TadakCompositionPageObject {
    
    func toDomain() -> TadakCompositionPage {
        return .init(
            version: self.version,
            compositions: self.compositions.map { $0.toDomain() }
        )
    }
}

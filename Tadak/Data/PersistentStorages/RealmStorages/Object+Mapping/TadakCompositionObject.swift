//
//  TadakCompositionObject.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import Foundation
import RealmSwift

final class TadakCompositionObject: Object {
    
    @Persisted(primaryKey: true) var version: String
    let compositions = List<CompositionObject>()
    
    convenience init(
        tadakComposition: TadakComposition
    ) {
        self.init()
        
        let version = tadakComposition.version
        let compositions = tadakComposition.compositions
        let objects = compositions.map(CompositionObject.init)
        self.version = version
        self.compositions.append(objectsIn: objects)
    }
}

extension TadakCompositionObject {
    func toDomain() -> TadakComposition {
        return .init(
            version: self.version,
            compositions: self.compositions.map { $0.toDomain() }
        )
    }
}

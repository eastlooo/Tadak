//
//  MyCompositionObject.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import Foundation
import RealmSwift

final class MyCompositionObject: Object {
    
    let compositions = List<CompositionObject>()
    
    convenience init(
        myComposition: MyComposition
    ) {
        self.init()
        
        let compositions = myComposition.compositions
        let objects = compositions.map(CompositionObject.init)
        self.compositions.append(objectsIn: objects)
    }
}

extension MyCompositionObject {
    func toDomain() -> MyComposition {
        return .init(
            compositions: self.compositions.map { $0.toDomain() }
        )
    }
}

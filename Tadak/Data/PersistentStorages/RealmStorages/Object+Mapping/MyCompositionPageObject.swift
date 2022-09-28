//
//  MyCompositionPageObject.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import Foundation
import RealmSwift

final class MyCompositionPageObject: Object {
    
    @Persisted var compositions = List<MyCompositionObject>()
    
    convenience init(
        myComposition: MyCompositionPage
    ) {
        self.init()
        
        let compositions = myComposition.compositions
        let objects = compositions.map(MyCompositionObject.init)
        self.compositions.append(objectsIn: objects)
    }
}

extension MyCompositionPageObject {
    
    func toDomain() -> MyCompositionPage {
        return .init(
            compositions: self.compositions.map { $0.toDomain() }
        )
    }
}

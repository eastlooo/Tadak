//
//  TadakUserObject.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import Foundation
import RealmSwift

final class TadakUserObject: Object {
    @Persisted(primaryKey: true) var uid: String
    @Persisted var nickname: String
    @Persisted var characterID: Int
    
    convenience init(uid: String, nickname: String, characterID: Int) {
        self.init()
        self.uid = uid
        self.nickname = nickname
        self.characterID = characterID
    }
}

extension TadakUserObject {
    func toDomain() -> TadakUser {
        return .init(
            id: self.uid,
            nickname: self.nickname,
            characterID: self.characterID
        )
    }
}

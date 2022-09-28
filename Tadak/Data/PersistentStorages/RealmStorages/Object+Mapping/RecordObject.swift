//
//  RecordObject.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/28.
//

import Foundation
import RealmSwift

final class RecordObject: Object {
    
    @Persisted(primaryKey: true) var compositionID: String
    @Persisted var elapsedTime: Int
    @Persisted var typingSpeed: Int
    @Persisted var accuracy: Int
    
    convenience init(
        record: Record
    ) {
        self.init()
        
        self.compositionID = record.compositionID
        self.elapsedTime = record.elapsedTime
        self.typingSpeed = record.typingSpeed
        self.accuracy = record.accuracy
    }
}

extension RecordObject {
    
    func update(record: Record) {
        self.elapsedTime = record.elapsedTime
        self.typingSpeed = record.typingSpeed
        self.accuracy = record.accuracy
    }
    
    func toDomain() -> Record {
        return .init(
            compositionID: self.compositionID,
            elapsedTime: self.elapsedTime,
            typingSpeed: self.typingSpeed,
            accuracy: self.accuracy
        )
    }
}

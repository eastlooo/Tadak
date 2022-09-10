//
//  RealmError.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/10.
//

import Foundation

enum RealmError: LocalizedError {
    case failedInitialization
    case failedSafeWriting
    case emptyInMemoryIdentifier
}

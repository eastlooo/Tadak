//
//  FirebaseError.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import Foundation

enum FirebaseError: LocalizedError {
    case invalidRequest
    case emptyResult
    case decodeError
    case failedToDictionary
    case failedFetchRemoteConfig
}

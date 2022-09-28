//
//  RepositoryProvider.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/28.
//

import Foundation

final class RepositoryProvider: RepositoryProviderProtocol {
    
    func makeUserRepository() -> UserRepositoryProtocol {
        return UserRepository()
    }
    
    func makeCompositionRepository() -> CompositionRepositoryProtocol {
        return CompositionRepository()
    }
    
    func makeRecordRepository() -> RecordRepositoryProtocol {
        return RecordRepository()
    }
}

//
//  RepositoryProviderProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/28.
//

import Foundation

protocol RepositoryProviderProtocol {
    
    func makeUserRepository() -> UserRepositoryProtocol
    func makeCompositionRepository() -> CompositionRepositoryProtocol
    func makeRecordRepository() -> RecordRepositoryProtocol
}

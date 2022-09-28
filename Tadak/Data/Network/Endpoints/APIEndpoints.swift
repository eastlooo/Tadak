//
//  APIEndpoints.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/09.
//

import Foundation

struct APIEndpoints {
    
    // MARK: Nickname
    static func createNickname(with requestDTO: CreateNicknameRequestDTO, nickname: String) -> Endpoint<Void> {
        return .init(
            path: "nicknames/\(nickname)",
            crud: .create,
            bodyParameters: requestDTO
        )
    }
    
    static func readNickname(nickname: String) -> Endpoint<Void> {
        return .init(
            path: "nicknames/\(nickname)",
            crud: .read
        )
    }
    
    static func deleteNickname(nickname: String) -> Endpoint<Void> {
        return .init(
            path: "nicknames/\(nickname)",
            crud: .delete
        )
    }
    
    // MARK: User
    static func createUser(with requestDTO: CreateUserRequestDTO, uid: String) -> Endpoint<Void> {
        return .init(
            path: "users/\(uid)",
            crud: .create,
            bodyParameters: requestDTO
        )
    }
    
    static func readUser(uid: String) -> Endpoint<ReadUserResponseDTO> {
        return .init(
            path: "users/\(uid)",
            crud: .read
        )
    }
    
    static func deleteUser(uid: String) -> Endpoint<Void> {
        return .init(
            path: "users/\(uid)",
            crud: .delete
        )
    }
    
    // MARK: Composition
    static func readTadakCompositions() -> Endpoint<[TadakCompositionResponseDTO]> {
        return .init(
            path: "tadakComposition/compositions",
            crud: .read
        )
    }
    
    static func readTadakCompositionVersion() -> Endpoint<String> {
        return .init(
            path: "tadakComposition/version",
            crud: .read
        )
    }
}

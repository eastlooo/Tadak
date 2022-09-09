//
//  APIEndpoints.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/09.
//

import Foundation

struct APIEndpoints {
    
    static func readNickname(nickname: String) -> Endpoint<Void> {
        return .init(
            path: "nicknames/\(nickname)",
            crud: .read
        )
    }
    
    static func createUser(with requestDTO: CreateUserRequestDTO, uid: String) -> Endpoint<Void> {
        return .init(
            path: "users/\(uid)",
            crud: .create,
            bodyParameters: requestDTO
        )
    }
    
    static func createNickname(with requestDTO: CreateNicknameRequestDTO, nickname: String) -> Endpoint<Void> {
        return .init(
            path: "nicknames/\(nickname)",
            crud: .create,
            bodyParameters: requestDTO
        )
    }
}

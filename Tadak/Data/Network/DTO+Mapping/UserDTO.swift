//
//  UserDTO.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/09.
//

import Foundation

struct CreateUserRequestDTO: Encodable {
    
    let uid: String
    let nickname: String
    let characterID: Int
}

struct ReadUserResponseDTO: Decodable {
    
    let uid: String
    let nickname: String
    let characterID: Int
}

extension ReadUserResponseDTO {
    
    func toDomain() -> TadakUser {
        return .init(
            id: self.uid,
            nickname: self.nickname,
            characterID: self.characterID
        )
    }
}

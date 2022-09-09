//
//  APIEndpoints.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/09.
//

import Foundation

struct APIEndpoints {
    
    static func registerUser(with requestDTO: RegisterUserRequestDTO, uid: String) -> Endpoint<Void> {
        return .init(
            path: "users/\(uid)",
            crud: .create,
            bodyParameters: requestDTO
        )
    }
}

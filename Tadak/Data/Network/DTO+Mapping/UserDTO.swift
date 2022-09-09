//
//  UserDTO.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/09.
//

import Foundation

struct CreateUserRequestDTO: Encodable {
    let nickname: String
    let characterID: Int
}

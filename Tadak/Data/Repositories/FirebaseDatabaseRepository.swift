//
//  FirebaseDatabaseRepository.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/09.
//

import Foundation
import RxSwift

protocol FirebaseDatabaseRepositoryProtocol {
    func registerUser(uid: String, nickname: String, characterID: Int) -> Observable<Result<Void, Error>>
}

final class FirebaseDatabaseRepository {
    
    private let service: FirebaseDatabaseServiceProtocol
    
    init(
        service: FirebaseDatabaseServiceProtocol = FirebaseDatabaseService()
    ) {
        self.service = service
    }
}

extension FirebaseDatabaseRepository: FirebaseDatabaseRepositoryProtocol {
    func registerUser(uid: String, nickname: String, characterID: Int) -> Observable<Result<Void, Error>> {
        let requestDTO = RegisterUserRequestDTO(nickname: nickname, characterID: characterID)
        let endpoint = APIEndpoints.registerUser(with: requestDTO, uid: uid)
        return service.request(with: endpoint)
    }
}

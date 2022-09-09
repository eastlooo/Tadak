//
//  FirebaseDatabaseRepository.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/09.
//

import Foundation
import RxSwift

protocol FirebaseDatabaseRepositoryProtocol {
    func checkNicknameDuplication(nickname: String) -> Observable<Result<Void, Error>>
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
    
    func checkNicknameDuplication(nickname: String) -> Observable<Result<Void, Error>> {
        let endpoint = APIEndpoints.readNickname(nickname: nickname)
        return service.request(with: endpoint)
    }
    
    func registerUser(uid: String, nickname: String, characterID: Int) -> Observable<Result<Void, Error>> {
        let userRequestDTO = CreateUserRequestDTO(nickname: nickname, characterID: characterID)
        let nicknameRequestDTO = CreateNicknameRequestDTO(uid: uid)
        let userEndpoint = APIEndpoints.createUser(with: userRequestDTO, uid: uid)
        let nicknameEndpoint = APIEndpoints.createNickname(with: nicknameRequestDTO, nickname: nickname)
        return service.request(with: [userEndpoint, nicknameEndpoint])
    }
}

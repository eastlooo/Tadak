//
//  UserRepository.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/09.
//

import Foundation
import RxSwift
import RealmSwift

protocol UserRepositoryProtocol {
    func checkNicknameDuplication(nickname: String) -> Observable<Result<Void, Error>>
    func createUserOnServer(uid: String, nickname: String, characterID: Int) -> Observable<Result<Void, Error>>
    func deleteUserOnServer(uid: String, nickname: String) -> Observable<Result<Void, Error>>
    func saveUserOnStorage(uid: String, nickname: String, characterID: Int) -> Observable<Result<Void, Error>>
}

final class UserRepository {
    
    private let service: FirebaseDatabaseServiceProtocol
    private let storage: Storage
    
    init(
        service: FirebaseDatabaseServiceProtocol = FirebaseDatabaseService(),
        storage: Storage = try! RealmStorage()
    ) {
        self.service = service
        self.storage = storage
    }
}

extension UserRepository: UserRepositoryProtocol {
    
    func checkNicknameDuplication(nickname: String) -> Observable<Result<Void, Error>> {
        let endpoint = APIEndpoints.readNickname(nickname: nickname)
        return service.request(with: endpoint)
    }
    
    func createUserOnServer(uid: String, nickname: String, characterID: Int) -> Observable<Result<Void, Error>> {
        let userRequestDTO = CreateUserRequestDTO(nickname: nickname, characterID: characterID)
        let nicknameRequestDTO = CreateNicknameRequestDTO(uid: uid)
        let userEndpoint = APIEndpoints.createUser(with: userRequestDTO, uid: uid)
        let nicknameEndpoint = APIEndpoints.createNickname(with: nicknameRequestDTO, nickname: nickname)
        
        return service.request(with: [userEndpoint, nicknameEndpoint])
    }
    
    func deleteUserOnServer(uid: String, nickname: String) -> Observable<Result<Void, Error>> {
        let userEndpoint = APIEndpoints.deleteUser(uid: uid)
        let nicknameEndpoint = APIEndpoints.deleteNickname(nickname: nickname)
        
        return service.request(with: [userEndpoint, nicknameEndpoint])
    }
    
    func saveUserOnStorage(uid: String, nickname: String, characterID: Int) -> Observable<Result<Void, Error>> {
        let user = TadakUser(
            id: uid,
            nickname: nickname,
            characterID: characterID
        )
        let object = TadakUserObject(tadakUser: user)
        return storage.save(object: object)
    }
}

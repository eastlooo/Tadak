//
//  UserRepository.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/09.
//

import Foundation
import RxSwift
import RxRelay
import RealmSwift

final class UserRepository: UserRepositoryProtocol {
    
    var user: Observable<TadakUser?> { _user.asObservable() }
    
    private let _user: BehaviorRelay<TadakUser?> = .init(value: nil)
    
    private let databaseService: FirebaseDatabaseServiceProtocol
    private let authService: FirebaseAuthServiceProtocol
    private let remoteConfigSevice: FirebaseRemoteConfigServiceProtocol
    private let storage: Storage?
    
    init(
        databaseService: FirebaseDatabaseServiceProtocol = FirebaseDatabaseService(),
        authService: FirebaseAuthServiceProtocol = FirebaseAuthService(),
        remoteConfigSevice: FirebaseRemoteConfigServiceProtocol = FirebaseRemoteConfigService(),
        storage: Storage? = try? RealmStorage()
    ) {
        self.databaseService = databaseService
        self.authService = authService
        self.remoteConfigSevice = remoteConfigSevice
        self.storage = storage
    }
}

extension UserRepository {
    
    func checkNickname(nickname: String) -> Observable<Void> {
        let endpoint = APIEndpoints.readNickname(nickname: nickname)
        
        return databaseService.request(with: endpoint)
    }
    
    func signInUserAnonymously() -> Observable<String> {
        let signIn = authService.signInAnonymously()
        let signOut = authService.signOut()
        
        return signOut
            .flatMap { _ in signIn }
    }
    
    func createUser(uid: String, nickname: String, characterID: Int) -> Observable<TadakUser> {
        let userRequestDTO = CreateUserRequestDTO(
            uid: uid,
            nickname: nickname,
            characterID: characterID
        )
        let nicknameRequestDTO = CreateNicknameRequestDTO(uid: uid)
        let userEndpoint = APIEndpoints.createUser(with: userRequestDTO, uid: uid)
        let nicknameEndpoint = APIEndpoints.createNickname(with: nicknameRequestDTO, nickname: nickname)
        
        let user = TadakUser(
            id: uid,
            nickname: nickname,
            characterID: characterID
        )
        
        let request = databaseService.request(with: [userEndpoint, nicknameEndpoint])
            .map { _ in user }
            .do { [weak self] user in self?._user.accept(user) }
        
        guard let storage = self.storage else { return request }
        
        return request
            .flatMap { user -> Observable<TadakUser> in
                let object = TadakUserObject(tadakUser: user)
                
                return storage.save(object: object)
                    .map { _ in user }
                    .catchAndReturn(user)
            }
    }
    
    func deleteUser(uid: String, nickname: String) -> Observable<Void> {
        let userEndpoint = APIEndpoints.deleteUser(uid: uid)
        let nicknameEndpoint = APIEndpoints.deleteNickname(nickname: nickname)
        
        guard let deleteOnStorage = storage?.reset() else {
            return .error(FirebaseError.failedLoadStorage)
        }
        
        let deleteOnDatabase = databaseService.request(with: [userEndpoint, nicknameEndpoint])
        let deleteOnAuth = authService.deleteUser()
        
        return deleteOnStorage
            .flatMap { _ in deleteOnDatabase }
            .flatMap { _ in deleteOnAuth }
            .do { [weak self] _ in self?._user.accept(nil) }
    }
    
    func fetchUser() -> Observable<TadakUser?> {
        guard let uid = authService.userID else {
            _user.accept(nil)
            return .just(nil)
        }
        
        let endpoint = APIEndpoints.readUser(uid: uid)
        let requestOnSever = databaseService.request(with: endpoint)
            .map { Optional($0.toDomain()) }
            .do { [weak self] user in self?._user.accept(user) }
        
        guard let storage = self.storage else { return requestOnSever }
        
        return storage.fetch(TadakUserObject.self, predicate: nil, sorted: nil)
            .map { $0.map { $0.toDomain() } }
            .map { $0.filter { $0.id == uid } }
            .map(\.first)
            .flatMap { [weak self] user -> Observable<TadakUser?> in
                if let user = user {
                    self?._user.accept(user)
                    return .just(user)
                }
                else { return requestOnSever }
            }
    }
}

//
//  UserRepository.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/09.
//

import Foundation
import RxSwift
import RealmSwift
import Network

protocol UserRepositoryProtocol {
    
    var user: BehaviorSubject<TadakUser?> { get }
    
    func checkNicknameDuplication(nickname: String) -> Observable<Result<Void, Error>>
    func signInUserAnonymously() -> Observable<Result<String, Error>>
    func createUser(uid: String, nickname: String, characterID: Int) -> Observable<Result<Void, Error>>
    func deleteUser(uid: String, nickname: String) -> Observable<Result<Void, Error>>
    func fetchUser() -> Observable<Result<TadakUser?, Error>>
}

final class UserRepository {
    
    var user: BehaviorSubject<TadakUser?> { user$ }
    
    private let user$: BehaviorSubject<TadakUser?> = .init(value: nil)
    
    private let databaseService: FirebaseDatabaseServiceProtocol
    private let authService: FirebaseAuthServiceProtocol
    private let storage: Storage?
    
    init(
        databaseService: FirebaseDatabaseServiceProtocol = FirebaseDatabaseService(),
        authService: FirebaseAuthServiceProtocol = FirebaseAuthService(),
        storage: Storage? = try? RealmStorage()
    ) {
        self.databaseService = databaseService
        self.authService = authService
        self.storage = storage
    }
}

extension UserRepository: UserRepositoryProtocol {
    
    func checkNicknameDuplication(nickname: String) -> Observable<Result<Void, Error>> {
        let endpoint = APIEndpoints.readNickname(nickname: nickname)
        return databaseService.request(with: endpoint)
    }
    
    func signInUserAnonymously() -> Observable<Result<String, Error>> {
        authService.signInAnonymously()
    }
    
    func createUser(uid: String, nickname: String, characterID: Int) -> Observable<Result<Void, Error>> {
        let userRequestDTO = CreateUserRequestDTO(
            uid: uid,
            nickname: nickname,
            characterID: characterID
        )
        let nicknameRequestDTO = CreateNicknameRequestDTO(uid: uid)
        let userEndpoint = APIEndpoints.createUser(with: userRequestDTO, uid: uid)
        let nicknameEndpoint = APIEndpoints.createNickname(with: nicknameRequestDTO, nickname: nickname)
        
        return databaseService.request(with: [userEndpoint, nicknameEndpoint])
            .flatMapSuccessCase { [weak self] _ in
                let user = TadakUser(
                    id: uid,
                    nickname: nickname,
                    characterID: characterID
                )
                self?.user.onNext(user)
                let object = TadakUserObject(tadakUser: user)
                
                if let saveStorage = self?.storage?.save(object: object)
                    .map({ _ -> Result<Void, Error> in return .success(Void()) }) {
                        return saveStorage
                    }

                return .just(.success(Void()))
            }
    }
    
    func deleteUser(uid: String, nickname: String) -> Observable<Result<Void, Error>> {
        let userEndpoint = APIEndpoints.deleteUser(uid: uid)
        let nicknameEndpoint = APIEndpoints.deleteNickname(nickname: nickname)
        
        guard let deleteOnStorage = storage?.reset() else { return .just(.failure(NSError())) }
        let deleteOnDatabase = databaseService.request(with: [userEndpoint, nicknameEndpoint])
        let deleteOnAuth = authService.deleteUser()
        
        return deleteOnStorage
            .flatMapSuccessCase { _ in deleteOnDatabase }
            .flatMapSuccessCase { _ in deleteOnAuth }
            .do { [weak self] _ in self?.user.onNext(nil) }
    }
    
    func fetchUser() -> Observable<Result<TadakUser?, Error>> {
        guard let uid = authService.userID else { return .just(.success(nil)) }
        let endpoint = APIEndpoints.readUser(uid: uid)
        let requestOnSever = databaseService.request(with: endpoint)
            .mapSuccessCase { Optional($0.toDomain()) }
            .do { [weak self] result in
                if case let .success(user) = result {
                    self?.user.onNext(user)
                }
            }
        
        guard let storage = self.storage else { return requestOnSever }
        
        return storage.fetch(TadakUserObject.self, predicate: nil, sorted: nil)
            .map { $0.map { $0.toDomain() } }
            .map { $0.filter { $0.id == uid } }
            .map(\.first)
            .flatMap { [weak self] user -> Observable<Result<TadakUser?, Error>> in
                if let user = user {
                    self?.user.onNext(user)
                    return .just(.success(user))
                }
                else { return requestOnSever }
            }
    }
}

//
//  CompositionRepository.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import Foundation
import RxSwift

protocol CompositionRepositoryProtocol {
    
    func fetchTadakComposition() -> Observable<Result<TadakComposition, Error>>
    func fetchMyComposition() -> Observable<MyComposition?>
}

final class CompositionRepository {
    
    var tadakComposition: BehaviorSubject<TadakComposition?> = .init(value: nil)
    var myComposition: BehaviorSubject<MyComposition?> = .init(value: nil)
    
    private let databaseService: FirebaseDatabaseServiceProtocol
    private let remoteConfigService: FirebaseRemoteConfigServiceProtocol
    private let storage: Storage?
    
    init(
        databaseService: FirebaseDatabaseServiceProtocol = FirebaseDatabaseService(),
        remoteConfigService: FirebaseRemoteConfigServiceProtocol = FirebaseRemoteConfigService(),
        storage: Storage? = try? RealmStorage()
    ) {
        self.databaseService = databaseService
        self.remoteConfigService = remoteConfigService
        self.storage = storage
    }
}

extension CompositionRepository: CompositionRepositoryProtocol {
    
    func fetchTadakComposition() -> Observable<Result<TadakComposition, Error>> {
        
        let minimumVersion = checkTadakCompositionMinimumVersion()
        let requestOnServer = readTadakCompositionOnServer()
        
        guard let storage = self.storage else { return requestOnServer }
        let fetchOnStorage = storage.fetch(TadakCompositionObject.self, predicate: nil, sorted: nil)
            .map { $0.map { $0.toDomain() } }
        return Observable.combineLatest(fetchOnStorage, minimumVersion)
            .map { tadakCompositions, minimumVersion -> TadakComposition? in
                return tadakCompositions
                    .filter { minimumVersion.compare($0.version, options: .numeric) != .orderedDescending }
                    .first
            }
            .flatMap { [weak self] tadakComposition -> Observable<Result<TadakComposition, Error>> in
                if let tadakComposition = tadakComposition {
                    self?.tadakComposition.onNext(tadakComposition)
                    return .just(.success(tadakComposition))
                } else {
                    return requestOnServer
                }
            }
    }
    
    func fetchMyComposition() -> Observable<MyComposition?> {
        guard let storage = self.storage else { return .just(nil) }
        
        return storage.fetch(MyCompositionObject.self, predicate: nil, sorted: nil)
            .map { $0.first }
            .map { $0?.toDomain() }
    }
}

private extension CompositionRepository {
    
    func checkTadakCompositionMinimumVersion() -> Observable<String> {
        return remoteConfigService
            .fetchRemoteConfig("tadakCompositionMinimumVersion", type: String.self)
            .justReturnOnFailure("1.0.0")
    }
    
    func readTadakCompositionOnServer() -> Observable<Result<TadakComposition, Error>> {
        let versionEndpoint = APIEndpoints.readTadakCompositionVersion()
        let compositionsEndpoint = APIEndpoints.readCompositions()
        let versionRequest = databaseService.request(with: versionEndpoint)
        let compositionsRequest = databaseService.request(with: compositionsEndpoint)
        
        return versionRequest
            .flatMapOnSuccess { version -> Observable<Result<TadakComposition, Error>> in
                return compositionsRequest
                    .mapOnSuccess { responseDTO -> TadakComposition in
                        return .init(
                            version: version,
                            compositions: responseDTO.map { $0.toDomain() }
                        )
                }
            }
            .doAnotherOnSuccess { [weak self] tadakComposition -> Observable<Void> in
                guard let self = self, let storage = self.storage else {
                    return .just(Void())
                }
                
                self.tadakComposition.onNext(tadakComposition)
                let object = TadakCompositionObject(tadakComposition: tadakComposition)
                
                return storage.deleteAll(TadakCompositionObject.self)
                    .map { _ in object }
                    .flatMap(storage.save)
                    .map { _ in }
            }
    }
}

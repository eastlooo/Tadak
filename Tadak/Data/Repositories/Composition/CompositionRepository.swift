//
//  CompositionRepository.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import Foundation
import RxSwift

protocol CompositionRepositoryProtocol {
    
    var tadakComposition: BehaviorSubject<TadakComposition?> { get }
    var myComposition: BehaviorSubject<MyComposition?> { get }
    
    func fetchTadakComposition() -> Observable<TadakComposition>
    func fetchMyComposition() -> Observable<MyComposition?>
}

final class CompositionRepository {
    
    let tadakComposition: BehaviorSubject<TadakComposition?> = .init(value: nil)
    let myComposition: BehaviorSubject<MyComposition?> = .init(value: nil)
    
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
    
    func fetchTadakComposition() -> Observable<TadakComposition> {
        
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
            .flatMap { [weak self] tadakComposition -> Observable<TadakComposition> in
                if let tadakComposition = tadakComposition {
                    self?.tadakComposition.onNext(tadakComposition)
                    return .just(tadakComposition)
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
            .catchAndReturn("1.0.0")
    }
    
    func readTadakCompositionOnServer() -> Observable<TadakComposition> {
        let versionEndpoint = APIEndpoints.readTadakCompositionVersion()
        let compositionsEndpoint = APIEndpoints.readCompositions()
        let versionRequest = databaseService.request(with: versionEndpoint)
        let compositionsRequest = databaseService.request(with: compositionsEndpoint)
        
        let request = versionRequest
            .flatMap { version -> Observable<TadakComposition> in
                return compositionsRequest
                    .map { responseDTO -> TadakComposition in
                        return .init(
                            version: version,
                            compositions: responseDTO.map { $0.toDomain() }
                        )
                    }
            }
            .do { [weak self] tadakComposition in
                self?.tadakComposition.onNext(tadakComposition)
            }
        
        
        guard let storage = self.storage else { return request }
        
        return request
            .flatMap { tadakComposition -> Observable<TadakComposition> in
                let object = TadakCompositionObject(tadakComposition: tadakComposition)
                return storage.deleteAll(TadakCompositionObject.self)
                    .map { _ in object }
                    .flatMap(storage.save)
                    .map { _ in tadakComposition }
                    .catchAndReturn(tadakComposition)
            }
    }
}

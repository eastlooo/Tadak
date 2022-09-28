//
//  CompositionRepository.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import Foundation
import RxSwift

final class CompositionRepository: CompositionRepositoryProtocol {
    
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

extension CompositionRepository {
    
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
            .do { [weak self] myComposition in
                self?.myComposition.onNext(myComposition)
            }
    }
    
    func appendMyComposition(_ compostion: Composition) -> Observable<Void> {
        guard let storage = self.storage else { return .error(RealmError.failedInitialization) }
        
        let compositionObject = CompositionObject(composition: compostion)
        
        let myCompositonObject = storage.fetch(MyCompositionObject.self, predicate: nil, sorted: nil)
            .map { $0.first }
            .flatMap { object -> Observable<MyCompositionObject> in
                if let object = object {
                    return .just(object)
                }
                
                return storage.create(MyCompositionObject.self)
            }
        
        return myCompositonObject
            .flatMap { object -> Observable<MyComposition> in
                return storage
                    .update {
                        object.compositions.append(compositionObject)
                    }
                    .map { _ in object.toDomain() }
            }
            .do { [weak self] myComposition in
                self?.myComposition.onNext(myComposition)
            }
            .map { _ in }
    }
    
    func removeMyComposition(_ compostion: Composition) -> Observable<Void> {
        guard let storage = self.storage else { return .error(RealmError.failedInitialization) }
        
        let id = compostion.id
        
        let myCompositonObject = storage.fetch(MyCompositionObject.self, predicate: nil, sorted: nil)
            .compactMap { $0.first }
        
        return myCompositonObject
            .flatMap { object -> Observable<MyComposition> in
                return storage
                    .update {
                        object.compositions
                            .filter { $0.id == id  }
                            .first
                            .flatMap { object.compositions.firstIndex(of: $0) }
                            .flatMap { object.compositions.remove(at: $0) }
                    }
                    .map { _ in object.toDomain() }
            }
            .observe(on: MainScheduler.asyncInstance)
            .do { [weak self] myComposition in
                self?.myComposition.onNext(myComposition)
            }
            .map { _ in }
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
                    .do { _ = storage.save(object: $0) }
                    .map { _ in tadakComposition }
                    .catchAndReturn(tadakComposition)
            }
    }
}

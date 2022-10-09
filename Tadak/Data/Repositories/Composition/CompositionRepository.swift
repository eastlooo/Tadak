//
//  CompositionRepository.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import Foundation
import RxSwift

final class CompositionRepository: CompositionRepositoryProtocol {
    
    let tadakCompositionPage: BehaviorSubject<TadakCompositionPage?> = .init(value: nil)
    let myCompositionPage: BehaviorSubject<MyCompositionPage?> = .init(value: nil)
    
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
    
    func fetchTadakComposition() -> Observable<TadakCompositionPage> {
        let minimumVersion = checkTadakCompositionMinimumVersion()
        let requestOnServer = readTadakCompositionOnServer()
        
        guard let storage = self.storage else { return requestOnServer }
        
        let fetchOnStorage = storage.fetch(TadakCompositionPageObject.self, predicate: nil, sorted: nil)
            .map { $0.map { $0.toDomain() } }
        
        return Observable.combineLatest(fetchOnStorage, minimumVersion)
            .map { tadakCompositions, minimumVersion -> TadakCompositionPage? in
                return tadakCompositions
                    .filter { minimumVersion.compare($0.version, options: .numeric) != .orderedDescending }
                    .first
            }
            .flatMap { [weak self] tadakComposition -> Observable<TadakCompositionPage> in
                if let tadakComposition = tadakComposition {
                    self?.tadakCompositionPage.onNext(tadakComposition)
                    return .just(tadakComposition)
                } else {
                    return requestOnServer
                }
            }
    }
    
    func fetchMyComposition() -> Observable<MyCompositionPage?> {
        guard let storage = self.storage else { return .just(nil) }
        
        return storage.fetch(MyCompositionPageObject.self, predicate: nil, sorted: nil)
            .map { $0.first }
            .map { $0?.toDomain() }
            .do { [weak self] myComposition in
                self?.myCompositionPage.onNext(myComposition)
            }
    }
    
    func addMyComposition(_ compostion: MyComposition) -> Observable<Void> {
        guard let storage = self.storage else { return .error(RealmError.failedInitialization) }
        
        let compositionObject = MyCompositionObject(composition: compostion)
        
        let compositonPageObject = storage.fetch(MyCompositionPageObject.self, predicate: nil, sorted: nil)
            .map { $0.first }
            .flatMap { object -> Observable<MyCompositionPageObject> in
                if let object = object {
                    return .just(object)
                }
                
                return storage.create(MyCompositionPageObject.self)
            }
        
        return compositonPageObject
            .flatMap { object -> Observable<MyCompositionPage> in
                return storage
                    .update {
                        object.compositions.append(compositionObject)
                    }
                    .map { _ in object.toDomain() }
            }
            .do { [weak self] page in
                self?.myCompositionPage.onNext(page)
            }
            .map { _ in }
    }
    
    func removeMyComposition(_ compostion: MyComposition) -> Observable<Void> {
        guard let storage = self.storage else { return .error(RealmError.failedInitialization) }
        
        let id = compostion.id
        
        let myCompositonObject = storage.fetch(MyCompositionPageObject.self, predicate: nil, sorted: nil)
            .compactMap { $0.first }
        
        return myCompositonObject
            .flatMap { object -> Observable<MyCompositionPage> in
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
                self?.myCompositionPage.onNext(myComposition)
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
    
    func readTadakCompositionOnServer() -> Observable<TadakCompositionPage> {
        let versionEndpoint = APIEndpoints.readTadakCompositionVersion()
        let compositionsEndpoint = APIEndpoints.readTadakCompositions()
        let versionRequest = databaseService.request(with: versionEndpoint)
        let compositionsRequest = databaseService.request(with: compositionsEndpoint)
        
        let request = versionRequest
            .flatMap { version -> Observable<TadakCompositionPage> in
                return compositionsRequest
                    .map { responseDTO -> TadakCompositionPage in
                        return .init(
                            version: version,
                            compositions: responseDTO.map { $0.toDomain() }
                        )
                    }
            }
            .do { [weak self] page in
                self?.tadakCompositionPage.onNext(page)
            }
        
        guard let storage = self.storage else { return request }
        
        return request
            .flatMap { tadakComposition -> Observable<TadakCompositionPage> in
                return storage.deleteAll(TadakCompositionPageObject.self)
                    .map { _ in TadakCompositionPageObject(tadakComposition: tadakComposition) }
                    .flatMap(storage.save)
                    .map { _ in tadakComposition }
                    .catchAndReturn(tadakComposition)
            }
    }
}

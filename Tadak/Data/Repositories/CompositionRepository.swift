//
//  CompositionRepository.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import Foundation
import RxSwift

protocol CompositionRepositoryProtocol {
    func readTadakCompositionOnServer() -> Observable<Result<TadakComposition, Error>>
//    func readMyCompositionOnServer() -> Observable<Result<TadakComposition, Error>>
}

final class CompositionRepository {
    
    var tadakCompose: BehaviorSubject<TadakComposition?> = .init(value: nil)
    
    private let service: FirebaseDatabaseServiceProtocol
    private let storage: Storage?
    
    init(
        service: FirebaseDatabaseServiceProtocol = FirebaseDatabaseService(),
        storage: Storage? = try? RealmStorage()
    ) {
        self.service = service
        self.storage = storage
    }
}

extension CompositionRepository: CompositionRepositoryProtocol {
    func fetchTadakComposeOnStorage() {
        
    }
    
    func fetchMyComposeOnStorage() {
        
    }
    
    func readTadakCompositionOnServer() -> Observable<Result<TadakComposition, Error>> {
        let versionEndpoint = APIEndpoints.readTadakCompositionVersion()
        let compositionsEndpoint = APIEndpoints.readCompositions()
        let versionRequest = service.request(with: versionEndpoint)
        let compositionsRequest = service.request(with: compositionsEndpoint)

        return versionRequest.flatMap { result -> Observable<Result<TadakComposition, Error>> in
            switch result {
            case .success(let version):
                return compositionsRequest.map { result -> Result<TadakComposition, Error> in
                    switch result {
                    case .success(let responses):
                        let tadakComposition = TadakComposition(
                            version: version,
                            compositions: responses.map { $0.toDomain() }
                        )
                        return .success(tadakComposition)
                        
                    case .failure(let error): return .failure(error)
                    }
                }
                
            case .failure(let error): return .just(.failure(error))
            }
        }
    }
}

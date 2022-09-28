//
//  InitializationUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import Foundation
import RxSwift

final class InitializationUseCase: InitializationUseCaseProtocol {
    
    let user: Observable<TadakUser?>
    
    private let userRepository: UserRepositoryProtocol
    private let compositionRepository: CompositionRepositoryProtocol
    private let recordRepository: RecordRepositoryProtocol
    
    init(
        userRepository: UserRepositoryProtocol,
        compositionRepository: CompositionRepositoryProtocol,
        recordRepository: RecordRepositoryProtocol
    ) {
        self.user = userRepository.user
        self.userRepository = userRepository
        self.compositionRepository = compositionRepository
        self.recordRepository = recordRepository
    }
}

extension InitializationUseCase {
    
    func fetchUser() -> Observable<TadakUser?> {
        return userRepository.fetchUser()
            .retry(2)
            .catchAndReturn(nil)
    }
    
    func fetchCompositions() -> Observable<(TadakComposition, MyComposition)> {
        let tadakComposition = compositionRepository.fetchTadakComposition()
        let myComposition = compositionRepository.fetchMyComposition()
            .map { $0 ?? MyComposition(compositions: []) }
        
        return Observable.combineLatest(tadakComposition, myComposition)
    }
    
    func fetchRecords() -> Observable<[Record]> {
        return recordRepository.fetchRecords()
            .retry(2)
    }
}

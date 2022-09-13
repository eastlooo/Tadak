//
//  InitializationUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import Foundation
import RxSwift

protocol InitializationUseCaseProtocol: AnyObject {
    
    var user: BehaviorSubject<TadakUser?> { get }
    
    func fetchCompositions() -> Observable<Result<Void, Error>>
}

final class InitializationUseCase {
    
    var user: BehaviorSubject<TadakUser?> { user$ }
    
    private let user$: BehaviorSubject<TadakUser?>
    private let userRepository: UserRepositoryProtocol
    private let compositionRepository: CompositionRepositoryProtocol
    
    init(
        userRepository: UserRepositoryProtocol,
        compositionRepository: CompositionRepositoryProtocol
    ) {
        self.user$ = userRepository.user
        self.userRepository = userRepository
        self.compositionRepository = compositionRepository
    }
}

extension InitializationUseCase: InitializationUseCaseProtocol {
    
    func fetchCompositions() -> Observable<Result<Void, Error>> {
        let myComposition = compositionRepository.fetchMyComposition()
        let tadakComposition = compositionRepository.fetchTadakComposition()
        
        return myComposition
            .flatMap { _ in tadakComposition }
            .mapOnSuccess { _ -> Void in Void() }
    }
}

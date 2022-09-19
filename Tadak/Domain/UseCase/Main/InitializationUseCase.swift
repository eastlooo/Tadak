//
//  InitializationUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import Foundation
import RxSwift

protocol InitializationUseCaseProtocol: AnyObject {
    
    var user: Observable<TadakUser?> { get }
    
    func fetchCompositions() -> Observable<Void>
}

final class InitializationUseCase {
    
    let user: Observable<TadakUser?>
    
    private let userRepository: UserRepositoryProtocol
    private let compositionRepository: CompositionRepositoryProtocol
    
    init(
        userRepository: UserRepositoryProtocol,
        compositionRepository: CompositionRepositoryProtocol
    ) {
        self.user = userRepository.user
        self.userRepository = userRepository
        self.compositionRepository = compositionRepository
    }
}

extension InitializationUseCase: InitializationUseCaseProtocol {
    
    func fetchCompositions() -> Observable<Void> {
        let myComposition = compositionRepository.fetchMyComposition()
        let tadakComposition = compositionRepository.fetchTadakComposition()
        
        return myComposition
            .flatMap { _ in tadakComposition }
            .map { _ in }
    }
}

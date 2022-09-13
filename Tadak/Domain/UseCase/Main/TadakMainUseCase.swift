//
//  TadakMainUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/13.
//

import Foundation
import RxSwift

protocol TadakMainUseCaseProtocol: AnyObject {
    
    var user: BehaviorSubject<TadakUser?> { get }
}

final class TadakMainUseCase: TadakMainUseCaseProtocol {
    
    var user: BehaviorSubject<TadakUser?> { user$ }
    
    private let user$: BehaviorSubject<TadakUser?>
    private let userRepository: UserRepositoryProtocol
    
    init(
        userRepository: UserRepositoryProtocol
    ) {
        self.user$ = userRepository.user
        self.userRepository = userRepository
    }
}

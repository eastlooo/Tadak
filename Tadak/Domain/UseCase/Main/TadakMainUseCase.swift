//
//  TadakMainUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/13.
//

import Foundation
import RxSwift

protocol TadakMainUseCaseProtocol: AnyObject {
    
    var user: Observable<TadakUser?> { get }
}

final class TadakMainUseCase: TadakMainUseCaseProtocol {
    
    let user: Observable<TadakUser?>
    
    private let userRepository: UserRepositoryProtocol
    
    init(
        userRepository: UserRepositoryProtocol
    ) {
        self.user = userRepository.user
        self.userRepository = userRepository
    }
}

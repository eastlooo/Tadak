//
//  InitializationViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class InitializationViewReactor: Reactor, Stepper {
    
    enum Action {}
    
    enum Mutation {}
    
    struct State {
        var user: TadakUser
    }
    
    let initialState: State
    var steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    
    private let user: TadakUser
    private let initializationUseCase: InitializationUseCaseProtocol
    
    init(
        user: TadakUser,
        initializationUseCase: InitializationUseCaseProtocol
    ) {
        self.user = user
        self.initializationUseCase = initializationUseCase
        self.initialState = State(user: user)
        
        bind()
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

private extension InitializationViewReactor {
    
    func bind() {
        let step = TadakStep.initializationIsComplete(user: user)
        
        initializationUseCase.fetchCompositions()
            .debugError()
            .map { _ in step }
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
}

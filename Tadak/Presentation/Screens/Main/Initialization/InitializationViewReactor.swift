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
    
    enum Mutation {
        case setUser(TadakUser)
        case fetchCompositions(Void)
    }
    
    struct State {
        var user: TadakUser? = nil
    }
    
    let initialState: State
    var steps = PublishRelay<Step>()
    
    private let useCase: InitializationUseCaseProtocol
    
    init(useCase: InitializationUseCaseProtocol) {
        self.useCase = useCase
        self.initialState = State()
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension InitializationViewReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setUser(let user):
            state.user = user
            
        case .fetchCompositions:
            steps.accept(TadakStep.initializationIsComplete)
        }
        
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        
        let setUser = useCase.user
            .compactMap { $0 }
            .map(Mutation.setUser)
        
        let fetchCompositions = useCase.fetchCompositions()
            .map(Mutation.fetchCompositions)
            .debugError()
        
        return .merge(
            mutation,
            setUser,
            fetchCompositions
        )
    }
}

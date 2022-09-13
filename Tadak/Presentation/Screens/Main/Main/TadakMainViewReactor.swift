//
//  TadakMainViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/13.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class TadakMainViewReactor: Reactor, Stepper {
    
    enum Action {
        case tadakListButtonTapped(Void)
        case myListButtonTapped(Void)
        case settingButtonTapped(Void)
    }
    
    enum Mutation {
        case setUser(TadakUser)
    }
    
    struct State {
        var user: TadakUser? = nil
    }
    
    let initialState: State
    var steps = PublishRelay<Step>()
    
    private let useCase: TadakMainUseCaseProtocol
    
    init(useCase: TadakMainUseCaseProtocol) {
        self.useCase = useCase
        self.initialState = State()
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension TadakMainViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tadakListButtonTapped:
            steps.accept(TadakStep.tadakListIsRequired)
            return .empty()
            
        case .myListButtonTapped:
            steps.accept(TadakStep.myCompositionIsRequired)
            return .empty()
            
        case .settingButtonTapped:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setUser(let user):
            state.user = user
        }
        
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return .merge(
            mutation,
            useCase.user.compactMap { $0 }.map(Mutation.setUser)
        )
    }
}

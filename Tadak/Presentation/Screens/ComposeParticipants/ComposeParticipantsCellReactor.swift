//
//  ComposeParticipantsCellReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/17.
//

import Foundation
import ReactorKit

final class ComposeParticipantsCellReactor: Reactor {
    
    enum Action {
        case text(String)
    }
    
    enum Mutation {
        case setName(String)
    }
    
    struct State {
        var name: String = ""
    }
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension ComposeParticipantsCellReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .text(let name):
            return .just(Mutation.setName(name))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setName(let name):
            state.name = name
        }
        
        return state
    }
}

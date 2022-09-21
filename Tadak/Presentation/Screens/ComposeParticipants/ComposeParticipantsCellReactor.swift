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
        case changedText(String)
    }
    
    enum Mutation {
        case setName(String)
    }
    
    struct State {
        @Pulse var name: String = ""
        @Pulse var maxLength: Int
    }
    
    var disposeBag = DisposeBag()
    
    let name = PublishSubject<String>()
    let initialState: State
    
    init(maxLength: Int) {
        self.initialState = State(maxLength: maxLength)
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension ComposeParticipantsCellReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .changedText(let name):
            return .just(Mutation.setName(name))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setName(let text):
            state.name = text
        }
        
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let setName = name.map(Mutation.setName)
        
        return .merge(mutation, setName)
    }
}

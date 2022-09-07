//
//  OnboardingCharacterViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import Foundation
import ReactorKit

final class OnboardingCharacterViewReactor: Reactor {
    
    enum Action {
        case itemSelected(IndexPath)
    }
    
    enum Mutation {
        case findCharacterID(Int)
    }
    
    struct State {
        let items: [Int]
        var characterID: Int?
    }
    
    private let useCase: OnboardingCharacterUseCaseProtocol
    let initialState: State
    
    init(useCase: OnboardingCharacterUseCaseProtocol) {
        self.useCase = useCase
        self.initialState = State(items: useCase.characterIDs)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .itemSelected(indexPath):
            return Observable.just(Mutation.findCharacterID(indexPath.row))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .findCharacterID(let index):
            state.characterID = useCase.findCharacterID(index: index)
        }
        return state
    }
}

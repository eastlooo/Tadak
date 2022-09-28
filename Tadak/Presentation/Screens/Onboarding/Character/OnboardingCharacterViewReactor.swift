//
//  OnboardingCharacterViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class OnboardingCharacterViewReactor: Reactor, Stepper {

    enum Action {
        case itemSelected(IndexPath)
    }
    
    enum Mutation {}
    
    struct State {
        let items: [Int]
    }
    
    let initialState: State
    var steps = PublishRelay<Step>()
    
    private let useCase: OnboardingUseCaseProtocol
    
    init(useCase: OnboardingUseCaseProtocol) {
        self.useCase = useCase
        self.initialState = State(items: useCase.characterIDs)
    }
}

extension OnboardingCharacterViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .itemSelected(indexPath):
            let characterID = useCase.getCharacterId(at: indexPath.row)
            steps.accept(TadakStep.onboardingCharacterSelected(characterID: characterID))
            return .empty()
        }
    }
}

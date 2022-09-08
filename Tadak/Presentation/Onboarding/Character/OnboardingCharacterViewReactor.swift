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
import UIKit

final class OnboardingCharacterViewReactor: Reactor, Stepper {

    enum Action {
        case itemSelected(IndexPath)
    }
    
    enum Mutation {}
    
    struct State {
        let items: [Int]
    }
    
    private let useCase: OnboardingCharacterUseCaseProtocol
    let initialState: State
    var steps = PublishRelay<Step>()
    
    init(useCase: OnboardingCharacterUseCaseProtocol) {
        self.useCase = useCase
        self.initialState = State(items: useCase.characterIDs)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .itemSelected(indexPath):
            let characterID = useCase.findCharacterID(index: indexPath.row)
            steps.accept(OnboardingStep.onboardingCharacterSelected(withCharacterID: characterID))
            return .empty()
        }
    }
}





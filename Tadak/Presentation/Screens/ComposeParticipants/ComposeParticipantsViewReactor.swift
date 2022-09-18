//
//  ComposeParticipantsViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/17.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class ComposeParticipantsViewReactor: Reactor, Stepper {
    
    enum Action {
        case listButtonTapped(Void)
        case minusButtonTapped(Void)
        case plusButtonTapped(Void)
    }
    
    enum Mutation {}
    
    struct State {
        @Pulse var items: [ComposeParticipantsCellReactor] = []
        @Pulse var minimumNumber: Int
        @Pulse var maximumNumber: Int
        @Pulse var currentNumber: Int
    }
    
    var steps = PublishRelay<Step>()
    
    private let useCase: ComposeParticipantsUseCaseProtocol
    let initialState: State
    
    init(useCase: ComposeParticipantsUseCaseProtocol) {
        self.useCase = useCase
        self.initialState = State(
            minimumNumber: useCase.minimumNumber,
            maximumNumber: useCase.maximumNumber,
            currentNumber: useCase.minimumNumber
        )
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension ComposeParticipantsViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .listButtonTapped:
            steps.accept(TadakStep.participantsAreComplete)
            return .empty()
            
        case .minusButtonTapped:
            return .empty()
            
        case .plusButtonTapped:
            return .empty()
        }
    }
}

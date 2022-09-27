//
//  TadakListViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/13.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class TadakListViewReactor: Reactor, Stepper {
    
    enum Action {
        case homeButtonTapped(Void)
        case typingModeButtonTapped(TypingMode)
        case itemSelected(IndexPath)
    }
    
    enum Mutation {
        case setTypingMode(TypingMode)
        case setItems([Composition])
    }
    
    struct State {
        var typingMode: TypingMode = .practice
        var items: [Composition] = []
    }
    
    var steps = PublishRelay<Step>()
    private let typingMode$: BehaviorSubject<TypingMode> = .init(value: .practice)
    
    private let useCase: CompositionUseCaseProtocol
    let initialState: State
    
    init(useCase: CompositionUseCaseProtocol) {
        self.useCase = useCase
        self.initialState = State()
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension TadakListViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .homeButtonTapped:
            steps.accept(TadakStep.listIsComplete)
            return .empty()
            
        case .typingModeButtonTapped(let typingMode):
            typingMode$.onNext(typingMode)
            return .empty()
            
        case .itemSelected(let indexPath):
            return useCase.selectedTadakComposition(index: indexPath.row)
                .compactMap { $0 }
                .withLatestFrom(typingMode$) { ($1, $0) }
                .map(TypingDetail.init)
                .map(TadakStep.compositionIsPicked)
                .do(onNext: { [weak self] step in self?.steps.accept(step) })
                .flatMap { _ in Observable<Mutation>.empty() }
                .take(1)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setTypingMode(let typingMode):
            state.typingMode = typingMode
            
        case .setItems(let items):
            state.items = items
        }
        
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return .merge(
            mutation,
            useCase.tadakComposition
                .compactMap { $0?.compositions }
                .map(Mutation.setItems),
            typingMode$
                .map(Mutation.setTypingMode)
        )
    }
}

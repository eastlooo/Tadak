//
//  MyListViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/17.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class MyListViewReactor: Reactor, Stepper {
    
    enum Action {
        case homeButtonTapped(Void)
        case typingModeButtonTapped(TypingMode)
        case itemSelected(IndexPath)
        case deleteItem(IndexPath)
        case addButtonTapped(Void)
    }
    
    enum Mutation {
        case setTypingMode(TypingMode)
        case setItems([Composition])
    }
    
    struct State {
        @Pulse var typingMode: TypingMode = .practice
        @Pulse var items: [Composition] = []
    }
    
    var steps = PublishRelay<Step>()
    private let _typingMode: BehaviorSubject<TypingMode> = .init(value: .practice)
    
    private let useCase: CompositionUseCaseProtocol
    let initialState: State
    
    init(useCase: CompositionUseCaseProtocol) {
        self.useCase = useCase
        self.initialState = State()
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension MyListViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .homeButtonTapped:
            steps.accept(TadakStep.listIsComplete)
            return .empty()
            
        case .typingModeButtonTapped(let typingMode):
            _typingMode.onNext(typingMode)
            return .empty()
            
        case .itemSelected(let indexPath):
            let composition = useCase.selectedMyComposition(index: indexPath.row)
                .compactMap { $0 }
            
            return composition
                .withLatestFrom(_typingMode) { ($1, $0) }
                .map(TypingDetail.init)
                .map(TadakStep.myCompositionIsPicked)
                .do { [weak self] step in self?.steps.accept(step) }
                .flatMap { _ in Observable<Mutation>.empty() }
                .take(1)
            
        case .deleteItem(let indexPath):
            return useCase.removeMyComposition(index: indexPath.row)
                .flatMap { _ in Observable<Mutation>.empty() }
                .take(1)
            
        case .addButtonTapped:
            steps.accept(TadakStep.makeCompositionIsRequired)
            return .empty()
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
        let setItems = useCase.myComposition
            .compactMap { $0?.compositions }
            .map(Mutation.setItems)
        
        let setTypingMode = _typingMode.map(Mutation.setTypingMode)
        
        return .merge(
            mutation,
            setItems,
            setTypingMode
        )
    }
}

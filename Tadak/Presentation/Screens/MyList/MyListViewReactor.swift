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
    
//    private let useCase: TadakListUseCaseProtocol
    let initialState: State
    
    init() {
//        self.useCase = useCase
        self.initialState = State()
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension MyListViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .homeButtonTapped:
            steps.accept(TadakStep.myListIsComplete)
            return .empty()
            
        case .typingModeButtonTapped(let typingMode):
            typingMode$.onNext(typingMode)
            return .empty()
            
        case .itemSelected(let indexPath):
//            if let composition = useCase.getComposition(index: indexPath.row),
//               let typingMode = try? typingMode$.value() {
//                let typingDetail = TypingDetail(typingMode: typingMode, composition: composition)
//                steps.accept(TadakStep.compositionIsPicked(withTypingDetail: typingDetail))
//            }
            
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
        return .merge(
            mutation,
//            useCase.tadakComposition
//                .compactMap { $0?.compositions }
//                .map(Mutation.setItems),
            typingMode$
                .map(Mutation.setTypingMode)
        )
    }
}

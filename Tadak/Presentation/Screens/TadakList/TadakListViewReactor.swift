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
        case setItems([TadakListCellItem])
    }
    
    struct State {
        var typingMode: TypingMode = .practice
        var items: [TadakListCellItem] = []
    }
    
    var steps = PublishRelay<Step>()
    private let typingMode$: BehaviorSubject<TypingMode> = .init(value: .practice)
    
    private let compositionUseCase: CompositionUseCaseProtocol
    private let recordUseCase: RecordUseCaseProtocol
    let initialState: State
    
    init(
        compositionUseCase: CompositionUseCaseProtocol,
        recordUseCase: RecordUseCaseProtocol
    ) {
        self.compositionUseCase = compositionUseCase
        self.recordUseCase = recordUseCase
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
            let recordUseCase = recordUseCase
            
            return compositionUseCase.selectedTadakComposition(index: indexPath.row)
                .compactMap { $0 }
                .withLatestFrom(typingMode$) { ($1, $0) }
                .map(TypingDetail.init)
                .map { detail -> (TypingDetail, Int?) in
                    let id = detail.composition.id
                    let score = recordUseCase.getTypingSpeed(compositionID: id) ?? 0
                    return (detail, score)
                }
                .map(TadakStep.tadakCompositionIsPicked)
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
        let recordUseCase = recordUseCase
        
        let setItems = compositionUseCase.tadakComposition
            .compactMap(\.?.compositions)
            .map { compostions -> [TadakListCellItem] in
                compostions.map { composition -> TadakListCellItem in
                    let id = composition.id
                    let score = recordUseCase.getTypingSpeed(compositionID: id) ?? 0
                    return(composition, score)
                }
            }
            .map(Mutation.setItems)
            
        let setTypingMode = typingMode$
            .map(Mutation.setTypingMode)
        
        return .merge(
            mutation,
            setItems,
            setTypingMode
        )
    }
}

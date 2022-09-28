//
//  MakeCompositionViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/24.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class MakeCompositionViewReactor: Reactor, Stepper {
    
    enum Action {
        case listButtonTapped(Void)
        case saveButtonTapped(Void)
        case titleText(String)
        case artistText(String)
        case contentsText(String)
    }
    
    enum Mutation {
        case setValidate(Bool)
    }
    
    struct State {
        @Pulse var isValidate: Bool = false
    }
    
    private let disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    
    private let compositionUseCase: CompositionUseCaseProtocol
    let initialState: State
    
    init(compositionUseCase: CompositionUseCaseProtocol) {
        self.compositionUseCase = compositionUseCase
        self.initialState = State()
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension MakeCompositionViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .listButtonTapped:
            steps.accept(TadakStep.makeCompositionIsComplete)
            return .empty()
            
        case .saveButtonTapped:
            return compositionUseCase.saveComposition()
                .map { _ in TadakStep.makeCompositionIsComplete }
                .do { [weak self] step in self?.steps.accept(step) }
                .flatMap { _ in Observable<Mutation>.empty() }
                .take(1)
            
        case .titleText(let title):
            compositionUseCase.title.onNext(title)
            return .empty()
            
        case .artistText(let artist):
            compositionUseCase.artist.onNext(artist)
            return .empty()
            
        case .contentsText(let contents):
            compositionUseCase.contents.onNext(contents)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setValidate(let validate):
            state.isValidate = validate
        }
        
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let setValidate = compositionUseCase.checkValidate()
            .map(Mutation.setValidate)
        
        return Observable.merge(
            mutation,
            setValidate
        )
    }
}

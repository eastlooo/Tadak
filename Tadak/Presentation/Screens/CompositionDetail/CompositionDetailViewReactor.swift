//
//  CompositionDetailViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/13.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class CompositionDetailViewReactor: Reactor, Stepper {
    
    enum Action {
        case listButtonTapped(Void)
        case startButtonTapped(Void)
    }
    
    enum Mutation {}
    
    struct State {
        let typingDetail: TypingDetail
    }
    
    var steps = PublishRelay<Step>()
    private let _typingDetail: BehaviorSubject<TypingDetail>
    
    let initialState: State
    
    init(typingDetail: TypingDetail) {
        self._typingDetail = .init(value: typingDetail)
        self.initialState = State(typingDetail: typingDetail)
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension CompositionDetailViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .listButtonTapped:
            steps.accept(TadakStep.compositionDetailIsComplete)
            return .empty()
            
        case .startButtonTapped:
            return _typingDetail.map(TadakStep.participantsAreRequired)
                .do { [weak self] step in self?.steps.accept(step) }
                .flatMap { _ in Observable<Mutation>.empty() }
        }
    }
}

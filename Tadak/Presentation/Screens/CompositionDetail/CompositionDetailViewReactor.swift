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
    
    enum Mutation {
        case setScore(Int)
    }
    
    struct State {
        let typingDetail: TypingDetail
        let score: Int?
    }
    
    var steps = PublishRelay<Step>()
    let initialState: State
    
    private let _typingDetail: BehaviorSubject<TypingDetail>
    
    init(typingDetail: TypingDetail, score: Int? = nil) {
        self._typingDetail = .init(value: typingDetail)
        self.initialState = State(typingDetail: typingDetail, score: score)
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
            return _typingDetail
                .map { detail -> TadakStep in
                    switch detail.typingMode {
                    case .betting:
                        return .participantsAreRequired(typingDetail: detail)
                        
                    default:
                        return .typingIsRequired(typingDetail: detail)
                    }
                }
                .do { [weak self] step in self?.steps.accept(step) }
                .flatMap { _ in Observable<Mutation>.empty() }
        }
    }
}

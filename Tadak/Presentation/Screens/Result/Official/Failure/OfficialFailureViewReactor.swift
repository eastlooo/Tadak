//
//  OfficialFailureViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/26.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class OfficialFailureViewReactor: Reactor, Stepper {
    
    enum Action {
        case homeButtonTapped(Void)
        case retryButtonTapped(Void)
    }
    
    enum Mutation {}
    
    struct State {
        @Pulse var tyingSpeed: String
    }
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    
    init(tyingSpeed: Int) {
       
        self.initialState = State(tyingSpeed: "\(tyingSpeed)")
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension OfficialFailureViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .homeButtonTapped:
            steps.accept(TadakStep.practiceResultIsComplete)
            return .empty()
            
        case .retryButtonTapped:
            AnalyticsManager.log(TypingEvent.retry)
            steps.accept(TadakStep.typingIsRequiredAgain)
            return .empty()
        }
    }
}

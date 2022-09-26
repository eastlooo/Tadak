//
//  OfficialSuccessViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/26.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class OfficialSuccessViewReactor: Reactor, Stepper {
    
    enum Action {
        case homeButtonTapped(Void)
        case shareButtonTapped(Void)
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

extension OfficialSuccessViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .homeButtonTapped:
            steps.accept(TadakStep.practiceResultIsComplete)
            return .empty()
            
        case .shareButtonTapped:
            
            return .empty()
        }
    }
}

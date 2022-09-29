//
//  ResetAlertReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/29.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class ResetAlertReactor: Reactor, Stepper {
    
    enum Action {
        case defaultButtonTapped(Void)
        case cancelButtonTapped(Void)
    }
    
    enum Mutation {}
    
    struct State {}
    
    var steps = PublishRelay<Step>()
    let initialState: State
    
    init() {
        self.initialState = State()
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension ResetAlertReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .defaultButtonTapped:
            steps.accept(TadakStep.resetIsRequired)
            return .empty()
            
        case .cancelButtonTapped:
            steps.accept(TadakStep.resetAlertIsComplete)
            return .empty()
        }
    }
}

//
//  TadakMainViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/13.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class TadakMainViewReactor: Reactor, Stepper {
    
    enum Action {
        case tadakListButtonTapped(Void)
        case myListButtonTapped(Void)
        case settingButtonTapped(Void)
    }
    
    enum Mutation {}
    
    struct State {
        var user: TadakUser
    }
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    
    init(user: TadakUser) {
        self.initialState = State(user: user)
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension TadakMainViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tadakListButtonTapped:
            steps.accept(TadakStep.tadakListIsRequired)
            return .empty()
            
        case .myListButtonTapped:
            steps.accept(TadakStep.myListIsRequired)
            return .empty()
            
        case .settingButtonTapped:
            return state.map(\.user)
                .map(TadakStep.settingsIsRequired)
                .do { [weak self] step in self?.steps.accept(step) }
                .flatMap { _ in Observable<Mutation>.empty() }
        }
    }
}

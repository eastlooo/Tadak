//
//  BettingResultViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/24.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class BettingResultViewReactor: Reactor, Stepper {
    
    enum Action {
        case homeButtonTapped(Void)
    }
    
    enum Mutation {}
    
    struct State {
        @Pulse var items: [Rank]
        @Pulse var topTwo: (String, String)?
        @Pulse var topThree: (String, String, String)?
    }
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    
    init(composition: any Composition, ranking: [Rank]) {
        self.initialState = State(items: ranking)
        
        let title = composition.title
        let records = ranking.map(\.record)
        
        if composition is TadakComposition {
            AnalyticsManager.log(TypingEvent.resultTadakBetting(title: title,
                                                                records: records))
        } else if composition is MyComposition {
            AnalyticsManager.log(TypingEvent.resultMyBetting(title: title,
                                                             records: records))
        }
        
        AppReviewManager.increaseActionCount(2)
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension BettingResultViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .homeButtonTapped:
            steps.accept(TadakStep.bettingResultIsComplete)
            return .empty()
        }
    }
    
    func transform(state: Observable<State>) -> Observable<State> {
        return state.map { state -> State in
            let names = state.items.map(\.name)
            var state = state
            
            state.topTwo = (names.count == 2) ? (names[0], names[1]) : nil
            state.topThree = (names.count > 2) ? (names[0], names[1], names[2]) : nil
            
            return state
        }
    }
}

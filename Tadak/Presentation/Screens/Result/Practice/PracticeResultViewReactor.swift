//
//  PracticeResultViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/23.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class PracticeResultViewReactor: Reactor, Stepper {
    
    enum Action {
        case homeButtonTapped(Void)
    }
    
    enum Mutation {}
    
    struct State {
        @Pulse var title: String
        @Pulse var record: Record
        @Pulse var items: [TypingText]
    }
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    
    init(practiceResult: PracticeResult) {
        self.initialState = State(
            title: practiceResult.composition.title,
            record: practiceResult.record,
            items: practiceResult.typingTexts
        )
        
        let composition = practiceResult.composition
        let title = composition.title
        let record = practiceResult.record
        
        if composition is TadakComposition {
            AnalyticsManager.log(TypingEvent.resultTadakPractice(title: title, record: record))
        } else if composition is MyComposition {
            AnalyticsManager.log(TypingEvent.resultMyPractice(title: title, record: record))
        }
        
        AppReviewManager.increaseActionCount()
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension PracticeResultViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .homeButtonTapped:
            steps.accept(TadakStep.practiceResultIsComplete)
            return .empty()
        }
    }
}

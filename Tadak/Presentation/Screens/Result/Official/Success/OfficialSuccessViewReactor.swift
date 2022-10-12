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
        @Pulse var tyingSpeed: Int
    }
    
    var steps = PublishRelay<Step>()
    let initialState: State
    
    private let disposeBag = DisposeBag()
    private let title: String
    private let record: Record
    private let recordUseCase: RecordUseCaseProtocol
    
    init(
        title: String,
        record: Record,
        recordUseCase: RecordUseCaseProtocol
    ) {
        self.title = title
        self.record = record
        self.recordUseCase = recordUseCase
        self.initialState = State(tyingSpeed: record.typingSpeed)
        
        recordUseCase.updateRecord(record)
            .bind(onNext: { _ in })
            .disposed(by: disposeBag)
        
        AnalyticsManager.log(TypingEvent.resultTadakOfficial(title: title, record: record))
        AppReviewManager.increaseActionCount()
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
            AnalyticsManager.log(TypingEvent.share)
            AppReviewManager.increaseActionCount()
            steps.accept(TadakStep.shareResultIsRequired(title: title, score: record.typingSpeed))
            return .empty()
        }
    }
}

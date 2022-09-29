//
//  BettingTypingViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/21.
//

import Foundation
import ReactorKit
import RxFlow
import RxCocoa

final class BettingTypingViewReactor: Reactor, Stepper {
    
    enum Action {
        case homeButtonTapped(Void)
        case typingAttributesHasSet(TypingAttributes)
        case typingHasStarted(Void)
        case currentUserText(String)
        case returnPressed(Void)
    }
    
    enum Mutation {
        case setParticpant(String)
        case setCurrentOriginalText(String)
        case setNextOriginalText(String)
        case setUserText(String)
        case setProgression(Double)
        case setAcceleration(Int)
        case reset(Bool)
    }
    
    struct State {
        @Pulse var title: String
        @Pulse var participant: String = ""
        @Pulse var currentOriginalText: String = ""
        @Pulse var nextOriginalText: String = ""
        @Pulse var userText: String = ""
        @Pulse var progression: Double = 0
        @Pulse var acceleration: Int = 0
        @Pulse var shouldReset: Bool = false
    }
    
    var steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    
    private let typingUseCase: TypingUseCaseProtocol
    private let recordUseCase: BettingRecordUseCaseProtocol
    private let composition: any Composition
    let initialState: State
    
    init(
        typingUseCase: TypingUseCaseProtocol,
        recordUseCase: BettingRecordUseCaseProtocol
    ) {
        self.typingUseCase = typingUseCase
        self.recordUseCase = recordUseCase
        self.composition = typingUseCase.composition
        self.initialState = State(title: composition.title)
        
        bind()
        
        let title = composition.title
        let artist = composition.artist
        let number = recordUseCase.numOfParticipants
        
        if composition is TadakComposition {
            AnalyticsManager.log(TypingEvent.startTadakBetting(title: title,
                                                               artist: artist,
                                                               numOfParticipants: number))
        } else if composition is MyComposition {
            AnalyticsManager.log(TypingEvent.startMyBetting(title: title,
                                                               artist: artist,
                                                               numOfParticipants: number))
        }
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension BettingTypingViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .homeButtonTapped:
            steps.accept(TadakStep.typingIsComplete)
            return .empty()
            
        case .typingAttributesHasSet(let attributes):
            typingUseCase.updateTypingAttributes(attributes)
            return .empty()
            
        case .typingHasStarted:
            typingUseCase.start()
            return .empty()
            
        case .currentUserText(let text):
            typingUseCase.currentUserText.onNext(text)
            return .empty()
            
        case .returnPressed(let pressed):
            typingUseCase.returnPressed.onNext(pressed)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setParticpant(let name):
            state.participant = name
            
        case .setCurrentOriginalText(let currentOriginalText):
            state.currentOriginalText = currentOriginalText
            
        case .setNextOriginalText(let nextOriginalText):
            state.nextOriginalText = nextOriginalText
            
        case .setUserText(let text):
            state.userText = text
            
        case .setProgression(let progression):
            state.progression = progression
            
        case .setAcceleration(let acceleration):
            state.acceleration = acceleration
            
        case .reset(let reset):
            typingUseCase.reset()
            state.shouldReset = reset
        }
        
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        
        let setParticipant = recordUseCase.participant
            .map(Mutation.setParticpant)
        let setCurrentOriginalText = typingUseCase.currentOriginalText
            .map(Mutation.setCurrentOriginalText)
        let setNextOriginalText = typingUseCase.nextOriginalText
            .map(Mutation.setNextOriginalText)
        let setUserText = typingUseCase.userTextToBeUpdated
            .map(Mutation.setUserText)
        let setProgression = typingUseCase.progression
            .map(Mutation.setProgression)
        let setAcceleration = typingUseCase.acceleration
            .map(Mutation.setAcceleration)
        
        let reset = typingUseCase.finished
            .withLatestFrom(recordUseCase.participant)
            .withLatestFrom(typingUseCase.getRecord()) { ($0, $1) }
            .do(onNext: recordUseCase.updateRecord)
            .map { _ in true }
            .map(Mutation.reset)
        
        return .merge(
            mutation,
            setParticipant,
            setCurrentOriginalText,
            setNextOriginalText,
            setUserText,
            setProgression,
            setAcceleration,
            reset
        )
    }
}

private extension BettingTypingViewReactor {
    
    func bind() {
        let composition = composition
        recordUseCase.finished
            .withLatestFrom(recordUseCase.getRankingTable()) { (composition, $1) }
            .map(TadakStep.bettingResultIsRequired)
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
}

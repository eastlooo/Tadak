//
//  OfficialTypingViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/24.
//

import Foundation
import ReactorKit
import RxFlow
import RxCocoa

final class OfficialTypingViewReactor: Reactor, Stepper {
    
    enum Action {
        case homeButtonTapped(Void)
        case typingAttributesHasSet(TypingAttributes)
        case typingHasStarted(Void)
        case currentUserText(String)
        case returnPressed(Void)
        case viewDidDisappear(Bool)
        case abused(Abuse)
    }
    
    enum Mutation {
        case setCurrentOriginalText(String)
        case setNextOriginalText(String)
        case setUserText(String)
        case setElapsedTime(Int)
        case setAccuracy(Int)
        case setTypingSpeed(Int)
        case setProgression(Double)
        case reset(Bool)
    }
    
    struct State {
        @Pulse var title: String
        @Pulse var currentOriginalText: String = ""
        @Pulse var nextOriginalText: String = ""
        @Pulse var userText: String = ""
        @Pulse var elapsedTime: Int = 0
        @Pulse var accuracy: Int = 0
        @Pulse var typingSpeed: Int = 0
        @Pulse var progression: Double = 0
        @Pulse var shouldReset: Bool = false
    }
    
    var steps = PublishRelay<Step>()
    private var disposeBag = DisposeBag()
    
    private var useCase: TypingUseCaseProtocol
    private let composition: any Composition
    let initialState: State
    
    init(useCase: TypingUseCaseProtocol) {
        self.useCase = useCase
        self.composition = useCase.composition
        self.initialState = State(title: composition.title)
        
        bind()
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension OfficialTypingViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .homeButtonTapped:
            steps.accept(TadakStep.typingIsComplete)
            return .empty()
            
        case .typingAttributesHasSet(let attributes):
            useCase.updateTypingAttributes(attributes)
            return .empty()
            
        case .typingHasStarted:
            useCase.start()
            return .empty()
            
        case .currentUserText(let text):
            useCase.currentUserText.onNext(text)
            return .empty()
            
        case .returnPressed(let pressed):
            useCase.returnPressed.onNext(pressed)
            return .empty()
            
        case .viewDidDisappear:
            return .just(.reset(true))
            
        case .abused(let abuse):
            AnalyticsManager.log(TypingEvent.abuse(abuse: abuse))
            steps.accept(TadakStep.abused(abuse: abuse))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setCurrentOriginalText(let currentOriginalText):
            state.currentOriginalText = currentOriginalText
            
        case .setNextOriginalText(let nextOriginalText):
            state.nextOriginalText = nextOriginalText
            
        case .setUserText(let text):
            state.userText = text
            
        case .setElapsedTime(let time):
            state.elapsedTime = time
            
        case .setAccuracy(let accuracy):
            state.accuracy = accuracy
            
        case .setTypingSpeed(let speed):
            state.typingSpeed = speed
            
        case .setProgression(let progression):
            state.progression = progression
            
        case .reset(let reset):
            useCase.reset()
            disposeBag = DisposeBag()
            bind()
            state.shouldReset = reset
        }
        
        return state
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
//        let abused = useCase.abused.map(Action.abused).observe(on: MainScheduler.asyncInstance)
        
        return .merge(
            action
//            abused
        )
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let setCurrentOriginalText = useCase.currentOriginalText
            .map(Mutation.setCurrentOriginalText)
        let setNextOriginalText = useCase.nextOriginalText
            .map(Mutation.setNextOriginalText)
        let setUserText = useCase.userTextToBeUpdated.map(Mutation.setUserText)
        let setElapsedTime = useCase.elapesdTime.map(Mutation.setElapsedTime)
        let setAccuracy = useCase.accuracy.map(Mutation.setAccuracy)
        let setTypingSpeed = useCase.typingSpeed.map(Mutation.setTypingSpeed)
        let setProgression = useCase.progression.map(Mutation.setProgression)
        
        return .merge(
            mutation,
            setCurrentOriginalText,
            setNextOriginalText,
            setElapsedTime,
            setUserText,
            setAccuracy,
            setTypingSpeed,
            setProgression
        )
    }
}

private extension OfficialTypingViewReactor {
    
    func bind() {
        let record = useCase.getRecord()
        useCase.finished
            .withLatestFrom(useCase.accuracy)
            .filter { $0 == 100 }
            .withLatestFrom(record)
            .map(TadakStep.officialSuccessIsRequired)
            .take(1)
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        useCase.wrong
            .withLatestFrom(useCase.typingSpeed)
            .map(TadakStep.officialFailureIsRequired)
            .take(1)
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
}

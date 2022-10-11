//
//  PracticeTypingViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/14.
//

import Foundation
import ReactorKit
import RxFlow
import RxCocoa

final class PracticeTypingViewReactor: Reactor, Stepper {
    
    enum Action {
        case homeButtonTapped(Void)
        case typingAttributesHasSet(TypingAttributes)
        case typingHasStarted(Void)
        case currentUserText(String)
        case returnPressed(Void)
        case viewDidDisappear(Bool)
        case adDisappeared(Void)
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
        case showAd(Bool)
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
        @Pulse var adAppear: Bool = false
    }
    
    var steps = PublishRelay<Step>()
    private let _practicResult = BehaviorRelay<PracticeResult?>(value: nil)
    
    private let useCase: TypingUseCaseProtocol
    private let composition: any Composition
    let initialState: State
    
    init(useCase: TypingUseCaseProtocol) {
        self.useCase = useCase
        self.composition = useCase.composition
        self.initialState = State(title: composition.title)
        
        let title = composition.title
        let artist = composition.artist
        
        if composition is TadakComposition {
            AnalyticsManager.log(TypingEvent.startTadakPractice(title: title, artist: artist))
        } else if composition is MyComposition {
            AnalyticsManager.log(TypingEvent.startMyPractice(title: title, artist: artist))
        }
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension PracticeTypingViewReactor {
    
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
            
        case .adDisappeared:
            return _practicResult
                .compactMap { $0 }
                .map(TadakStep.practiceResultIsRequired)
                .take(1)
                .do { [weak self] step in self?.steps.accept(step) }
                .flatMap { _ in Observable<Mutation>.empty() }
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
            state.shouldReset = reset
            
        case .showAd(let show):
            state.adAppear = show
        }
        
        return state
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
        let showAd = showAd()
        
        return .merge(
            mutation,
            setCurrentOriginalText,
            setNextOriginalText,
            setElapsedTime,
            setUserText,
            setAccuracy,
            setTypingSpeed,
            setProgression,
            showAd
        )
    }
}

private extension PracticeTypingViewReactor {
    
    func showAd() -> Observable<Mutation> {
        let composition = composition
        let record = useCase.getRecord()
        let typingTexts = useCase.getTypingTexts()
        
        let practiceResult = Observable
            .combineLatest(record, typingTexts)
            .map { (composition, $0, $1) }
            .map(PracticeResult.init)
        
        return useCase.finished
            .withLatestFrom(practiceResult)
            .do { [weak self] result in self?._practicResult.accept(result) }
            .map { _ in Mutation.showAd(true) }
    }
}

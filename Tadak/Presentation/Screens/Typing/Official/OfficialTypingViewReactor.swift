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
        @Pulse var characterID: Int
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
    private let _record = BehaviorRelay<Record?>(value: nil)
    
    private var disposeBag = DisposeBag()
    
    private var typingUseCase: TypingUseCaseProtocol
    private let composition: any Composition
    let initialState: State
    
    init(
        user: TadakUser,
        typingUseCase: TypingUseCaseProtocol
    ) {
        self.typingUseCase = typingUseCase
        self.composition = typingUseCase.composition
        self.initialState = State(
            characterID: user.characterID,
            title: composition.title
        )
        
        bind()
        
        let title = composition.title
        let artist = composition.artist
        
        if composition is TadakComposition {
            AnalyticsManager.log(TypingEvent.startTadakOfficial(title: title, artist: artist))
        }
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
            
        case .viewDidDisappear:
            return .just(.reset(true))
            
        case .abused(let abuse):
            AnalyticsManager.log(TypingEvent.abuse(abuse: abuse))
            steps.accept(TadakStep.abused(abuse: abuse))
            return .empty()
            
        case .adDisappeared:
            let title = composition.title
            
            return _record
                .compactMap { $0 }
                .map { (title, $0) }
                .map(TadakStep.officialSuccessIsRequired)
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
            typingUseCase.reset()
            disposeBag = DisposeBag()
            bind()
            state.shouldReset = reset
            
        case .showAd(let show):
            state.adAppear = show
        }
        
        return state
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        let abused = typingUseCase.abused.map(Action.abused).observe(on: MainScheduler.asyncInstance)
        
        return .merge(
            action,
            abused
        )
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let setCurrentOriginalText = typingUseCase.currentOriginalText
            .map(Mutation.setCurrentOriginalText)
        let setNextOriginalText = typingUseCase.nextOriginalText
            .map(Mutation.setNextOriginalText)
        let setUserText = typingUseCase.userTextToBeUpdated.map(Mutation.setUserText)
        let setElapsedTime = typingUseCase.elapesdTime.map(Mutation.setElapsedTime)
        let setAccuracy = typingUseCase.accuracy.map(Mutation.setAccuracy)
        let setTypingSpeed = typingUseCase.typingSpeed.map(Mutation.setTypingSpeed)
        let setProgression = typingUseCase.progression.map(Mutation.setProgression)
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

private extension OfficialTypingViewReactor {
    
    func bind() {
        typingUseCase.wrong
            .withLatestFrom(typingUseCase.typingSpeed)
            .map(TadakStep.officialFailureIsRequired)
            .take(1)
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
    
    func showAd() -> Observable<Mutation> {
        let record = typingUseCase.getRecord()
        
        return typingUseCase.finished
            .withLatestFrom(typingUseCase.accuracy)
            .filter { $0 == 100 }
            .withLatestFrom(record)
            .do { [weak self] record in self?._record.accept(record) }
            .map { _ in Mutation.showAd(true) }
    }
}

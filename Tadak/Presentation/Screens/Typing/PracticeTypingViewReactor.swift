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
        case countDownIsFinished(Void)
        case typingAttributesIsSet(TypingAttributes)
        case typingHasStarted(Void)
        case typingText(String)
        case returnPressed(Void)
        case abused
    }
    
    enum Mutation {
        case setCurrentTyping(String?)
        case setNextTyping(String?)
        case setTypingText(String)
        case setElapsedTime(Int)
    }
    
    struct State {
        let title: String
        var currentTyping: String? = nil
        var nextTyping: String? = nil
        var typingText: String? = nil
        var elapsedTime: Int = 0
    }
    
    var steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    
    private let typingList$: BehaviorRelay<[String]> = .init(value: [])
    private let currentIndex$: BehaviorRelay<Int> = .init(value: 0)
    private let isRunning$: BehaviorRelay<Bool> = .init(value: false)
    private let timerValue$: BehaviorRelay<Int> = .init(value: 0)
    private let typingText$: BehaviorRelay<String> = .init(value: "")
    private let returnPressed$ = PublishRelay<Void>()
    private var currentTyping$: Observable<String> {
        Observable.combineLatest(typingList$, currentIndex$) { list, index -> String? in
            guard list.count > index else { return nil }
            return list[index]
        }
        .compactMap { $0 }
    }
    
    private let useCase: PracticeTypingUseCaseProtocol
    private let composition: Composition
    let initialState: State
    
    init(useCase: PracticeTypingUseCaseProtocol) {
        self.useCase = useCase
        self.composition = useCase.composition
        self.initialState = State(title: useCase.composition.title)
        
        bind()
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension PracticeTypingViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .homeButtonTapped:
            steps.accept(TadakStep.typingIsComplete)
            return .empty()
            
        case .countDownIsFinished:
            return .empty()
            
        case .typingAttributesIsSet(let typingAttributes):
            let contents = composition.contents
            let typingList = typingAttributes.seperateContents(contents)
            typingList$.accept(typingList)
            return .empty()
            
        case .typingHasStarted:
            isRunning$.accept(true)
            return .empty()
            
        case .typingText(let text):
            typingText$.accept(text)
            return .empty()
            
        case .returnPressed(let pressed):
            returnPressed$.accept(pressed)
            return .empty()
            
        case .abused:
            print("DEBUG: abused..")
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setCurrentTyping(let currentTyping):
            state.currentTyping = currentTyping
            
        case .setNextTyping(let nextTyping):
            state.nextTyping = nextTyping
            
        case .setTypingText(let text):
            state.typingText = text
            
        case .setElapsedTime(let time):
            state.elapsedTime = time
        }
        
        return state
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        let abused = action
            .compactMap { action -> String? in
                guard case let .typingText(text) = action else { return nil }
                return text
            }
            .withLatestFrom(typingText$) { ($0.count - $1.count) >= 2 }
            .filter { $0 }
            .map { _ in Action.abused }
        
        return .merge(action, abused)
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        
        let setTyping = Observable
            .combineLatest(typingList$, currentIndex$)
            .flatMap { (list: [String], index: Int) -> Observable<Mutation> in
                let currentTyping = (index < list.count) ? list[index] : nil
                let nextTyping = (index+1 < list.count) ? list[index+1] : nil
                return .merge(
                    .just(.setCurrentTyping(currentTyping)),
                    .just(.setNextTyping(nextTyping))
                )
            }
        
        let setTypingText = typingText$.map(Mutation.setTypingText)
        
        let setElapsedTime = timerValue$
            .map(Mutation.setElapsedTime)
        
        return .merge(mutation, setTyping, setElapsedTime, setTypingText)
    }
}

private extension PracticeTypingViewReactor {
    
    func bind() {
        let loop = Driver<Int>.interval(.seconds(1)).map { _ in 1 }
        
        isRunning$
            .filter { $0 }
            .take(1)
            .flatMap { _ in loop }
            .withLatestFrom(timerValue$) { $0 + $1 }
            .bind(to: timerValue$)
            .disposed(by: disposeBag)
        
        let typingToBeChanged = Observable.merge(
            typingText$
                .withLatestFrom(currentTyping$) { input, original -> String? in
                    guard input.count > original.count, original.count > 0 else { return nil }
                    let index = input.index(input.startIndex, offsetBy: original.count)
                    return String(input[index...])
                }
                .compactMap { $0 },
            returnPressed$
                .withLatestFrom(
                    Observable.combineLatest(typingText$, currentTyping$)
                )
                .compactMap { input, original -> String? in
                    guard input.count == original.count else { return nil }
                    return ""
                }
        )
            .share()
        
        typingToBeChanged
            .withLatestFrom(currentIndex$) { $1 + 1 }
            .bind(to: currentIndex$)
            .disposed(by: disposeBag)
        
        typingToBeChanged
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: typingText$)
            .disposed(by: disposeBag)
    }
}

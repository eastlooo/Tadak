//
//  ComposeParticipantsViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/17.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class ComposeParticipantsViewReactor: Reactor, Stepper {
    
    enum Action {
        case listButtonTapped(Void)
        case minusButtonTapped(Void)
        case plusButtonTapped(Void)
        case startButtonTapped(Void)
    }
    
    enum Mutation {
        case setItems([ComposeParticipantsCellReactor])
        case setMinimumNumber(Int)
        case setMaximumNumber(Int)
        case setCurrentNumber(Int)
        case setValidate(Bool)
    }
    
    struct State {
        @Pulse var items: [ComposeParticipantsCellReactor] = []
        @Pulse var minimumNumber: Int?
        @Pulse var maximumNumber: Int?
        @Pulse var currentNumber: Int?
        @Pulse var isValidate: Bool = false
    }
    
    private let disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    private let items: BehaviorRelay<[ComposeParticipantsCellReactor]> = .init(value: [])
    
    private let typingDetail: TypingDetail
    private let useCase: ComposeParticipantsUseCaseProtocol
    let initialState: State
    
    init(
        typingDetail: TypingDetail,
        useCase: ComposeParticipantsUseCaseProtocol
    ) {
        self.typingDetail = typingDetail
        self.useCase = useCase
        self.initialState = State()
        
        bind()
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension ComposeParticipantsViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .listButtonTapped:
            steps.accept(TadakStep.participantsAreComplete)
            return .empty()
            
        case .minusButtonTapped:
            useCase.decreaseNumber()
            return .empty()
            
        case .plusButtonTapped:
            useCase.increaseNumber()
            return .empty()
            
        case .startButtonTapped:
            steps.accept(TadakStep.typingIsRequired(withTypingDetail: typingDetail))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setItems(let items):
            state.items = items
            
        case .setMinimumNumber(let number):
            state.minimumNumber = number
            
        case .setMaximumNumber(let number):
            state.maximumNumber = number
            
        case .setCurrentNumber(let number):
            state.currentNumber = number
            
        case .setValidate(let validate):
            state.isValidate = validate
        }
        
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let setMinimumNumber = useCase.minNumber.map(Mutation.setMinimumNumber)
        let setMaximumNumber = useCase.maxNumber.map(Mutation.setMaximumNumber)
        let setCurrentNumber = useCase.currentNumber.map(Mutation.setCurrentNumber)
        let setItems = items.map(Mutation.setItems)
        let setValidate = useCase.isValidate.map(Mutation.setValidate)
        
        return .merge(
            mutation,
            setMinimumNumber,
            setMaximumNumber,
            setCurrentNumber,
            setItems,
            setValidate
        )
    }
}

private extension ComposeParticipantsViewReactor {
    
    func bind() {
        useCase.names
            .withLatestFrom(items) { (names: $0, items: $1) }
            .filter { $0.names.count > $0.items.count }
            .withLatestFrom(useCase.maxNameLength) { ($0.names, $0.items, $1) }
            .compactMap { [weak self] (names, items, maxLength) -> [ComposeParticipantsCellReactor]? in
                guard let self = self else { return nil }
                
                let prev = items
                let new = names[items.count...].enumerated()
                    .map { index, name -> ComposeParticipantsCellReactor in
                        let index = index + prev.count
                        let reactor = ComposeParticipantsCellReactor(maxLength: maxLength)
                        
                        reactor.name.onNext(name)

                        reactor.pulse(\.$name)
                            .skip(1)
                            .withLatestFrom(self.useCase.names) { new, list -> [String] in
                                var list = list
                                list[index] = new
                                return list
                            }
                            .bind(to: self.useCase.updateNames)
                            .disposed(by: reactor.disposeBag)
                        
                        return reactor
                    }
                
                return prev + new
            }
            .bind(to: items)
            .disposed(by: disposeBag)
        
        useCase.names
            .withLatestFrom(items) { ($0, $1) }
            .filter { $0.0.count < $0.1.count }
            .map { names, items in items[..<names.count].map { $0 } }
            .bind(to: items)
            .disposed(by: disposeBag)
    }
}

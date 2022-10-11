//
//  InitializationViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class InitializationViewReactor: Reactor, Stepper {
    
    enum Action {
        case viewDidAppear(Bool)
    }
    
    enum Mutation {}
    
    struct State {
        var user: TadakUser
    }
    
    let initialState: State
    var steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    
    private let user: TadakUser
    private let initializationUseCase: InitializationUseCaseProtocol
    
    init(
        user: TadakUser,
        initializationUseCase: InitializationUseCaseProtocol
    ) {
        self.user = user
        self.initializationUseCase = initializationUseCase
        self.initialState = State(user: user)
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension InitializationViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidAppear:
            return initialize()
        }
    }
}

private extension InitializationViewReactor {
    
    func initialize() -> Observable<Mutation> {
        let step = TadakStep.initializationIsComplete(user: user)
        
        let compositions = initializationUseCase.fetchCompositionPages()
        let records = initializationUseCase.fetchRecords()
        
        return Observable.combineLatest(compositions, records)
            .debugError()
            .map { _ in step }
            .do { [weak self] _ in self?.steps.accept(step) }
            .debug("qwerqwer")
            .flatMap { _ in Observable<Mutation>.empty() }
    }
}

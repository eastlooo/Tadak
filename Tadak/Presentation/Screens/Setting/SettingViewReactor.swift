//
//  SettingViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/29.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class SettingViewReactor: Reactor, Stepper {
    
    enum Action {
        case homeButtonTapped(Void)
        case itemSelected(IndexPath)
        case reset(Void)
    }
    
    enum Mutation {
        case showLoader(Bool)
    }
    
    struct State {
        @Pulse var items: [[Setting]]
        @Pulse var loaderAppear: Bool?
    }
    
    var steps = PublishRelay<Step>()
    let initialState: State
    
    private let user: TadakUser
    private let settingUseCase: SettingUseCaseProtocol
    
    init(
        user: TadakUser,
        settingUseCase: SettingUseCaseProtocol
    ) {
        let items: [[Setting]] = [
            [.contact, .writeReview],
            [.clearAllData]
        ]
        
        self.user = user
        self.settingUseCase = settingUseCase
        self.initialState = State(items: items)
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension SettingViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .homeButtonTapped:
            steps.accept(TadakStep.settingsIsComplete)
            return .empty()
            
        case .itemSelected(let indexPath):
            return mutateItemSelectedAction(indexPath: indexPath)
            
        case .reset:
            return mutateResetAction()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .showLoader(let show):
            state.loaderAppear = show
        }
        
        return state
    }
}

private extension SettingViewReactor {
    
    func mutateItemSelectedAction(indexPath: IndexPath) -> Observable<Mutation> {
        let canSendMail = settingUseCase.canSendMail()
        
        return pulse(\.$items)
            .map { $0[indexPath.section] }
            .map { $0[indexPath.row] }
            .compactMap { setting -> TadakStep? in
                switch setting {
                case .profile:
                    return nil
                    
                case .clearAllData:
                    return .resetAlertIsRequired
                    
                case .writeReview:
                    return .writeReviewIsRequired
                    
                case .contact:
                    return canSendMail ? .contactMailIsRequired : .mailDisableAlertIsRequired
                }
            }
            .do { [weak self] step in self?.steps.accept(step) }
            .flatMap { _ in Observable<Mutation>.empty() }
    }
    
    func mutateResetAction() -> Observable<Mutation> {
        let reset = settingUseCase.reset(user: user)
            .take(1)
            .debugError()
            .do { _ in AnalyticsManager.log(UserEvent.delete) }
            .map { _ in Mutation.showLoader(false) }
            .asDriver(onErrorJustReturn: .showLoader(false))
        
        let step = Observable<TadakStep>.just(.onboardingIsRequired)
            .do { [weak self] step in self?.steps.accept(step) }
            .flatMap { _ in Observable<Mutation>.empty() }
        
        return Observable.concat([
            .just(.showLoader(true)),
            reset.asObservable(),
            step
        ])
    }
}

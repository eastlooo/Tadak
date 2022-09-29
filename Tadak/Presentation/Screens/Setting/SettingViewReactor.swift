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
            [.contact],
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
        let canSendMail = settingUseCase.canSendMail()
        switch action {
        case .homeButtonTapped:
            steps.accept(TadakStep.settingsIsComplete)
            return .empty()
            
        case .itemSelected(let indexPath):
            return pulse(\.$items)
                .map { $0[indexPath.section] }
                .map { $0[indexPath.row] }
                .compactMap { setting -> TadakStep? in
                    switch setting {
                    case .profile:
                        return nil
                        
                    case .clearAllData:
                        return .resetAlertIsRequired
                        
                    case .contact:
                        return canSendMail ? .contactMailIsRequired : .mailDisableAlertIsRequired
                    }
                }
                .do { [weak self] step in self?.steps.accept(step) }
                .flatMap { _ in Observable<Mutation>.empty() }
            
        case .reset:
            let reset = settingUseCase.reset(user: user)
                .debugError()
                .do { _ in AnalyticsManager.log(UserEvent.delete) }
                .map { TadakStep.onboardingIsRequired }
                .do { [weak self] step in self?.steps.accept(step) }
                .map { _ in Mutation.showLoader(false) }
                .take(1)
                .asDriver(onErrorJustReturn: .showLoader(false))
            
            return Observable.concat([
                .just(.showLoader(true)),
                reset.asObservable()
            ])
        }
    }
}

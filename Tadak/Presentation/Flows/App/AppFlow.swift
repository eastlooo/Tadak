//
//  AppFlow.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import UIKit
import RxFlow

final class AppFlow: Flow {
    
    var root: Presentable { self.rootViewController }
    
    private let rootViewController = NavigationController()
    
    private let useCaseProvider: UseCaseProviderProtocol
    
    init(
        useCaseProvider: UseCaseProviderProtocol
    ) {
        self.useCaseProvider = useCaseProvider
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? TadakStep else { return .none }
        
        switch step {
        case .onboardingIsRequired:
            return switchToOnboardingFlow()
            
        case .initializationIsRequired(let user):
            return switchToMainFlow(user: user)
            
        default:
            return .none
        }
    }
}

private extension AppFlow {
    
    func switchToOnboardingFlow() -> FlowContributors {
        let onboardingFlow = OnboardingFlow(
            rootViewController: rootViewController,
            useCaseProvider: useCaseProvider
        )
        
        Flows.use(onboardingFlow, when: .created) { _ in }
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: onboardingFlow,
                withNextStepper: OneStepper(
                    withSingleStep: TadakStep.onboardingIsRequired)
            )
        )
    }
    
    func switchToMainFlow(user: TadakUser) -> FlowContributors {
        let mainFlow = MainFlow(
            rootViewController: rootViewController,
            useCaseProvider: useCaseProvider
        )
        
        Flows.use(mainFlow, when: .created) { _ in }
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: mainFlow,
                withNextStepper: OneStepper(
                    withSingleStep: TadakStep.initializationIsRequired(user: user))
            )
        )
    }
}

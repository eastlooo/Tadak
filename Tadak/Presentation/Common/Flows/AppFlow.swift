//
//  AppFlow.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import Foundation
import RxFlow

final class AppFlow: Flow {
    
    var root: Presentable { self.rootViewController }
    
    private lazy var rootViewController = NavigationController()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .onboardingIsRequired:
            return switchToOnboardingFlow()
            
        case .userIsRegisterd(let user):
            return switchToMainFlow(user: user)
        }
    }
}

private extension AppFlow {
    func switchToOnboardingFlow() -> FlowContributors {
        let onboardingFlow = OnboardingFlow(rootViewController: self.rootViewController)
        
        Flows.use(onboardingFlow, when: .created) { _ in }
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: onboardingFlow,
                withNextStepper: OneStepper(
                    withSingleStep: OnboardingStep.newUserEntered)
            )
        )
    }
    
    func switchToMainFlow(user: TadakUser) -> FlowContributors {
        let mainFlow = MainFlow(rootViewController: self.rootViewController)
        
        Flows.use(mainFlow, when: .created) { _ in }
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: mainFlow,
                withNextStepper: OneStepper(
                    withSingleStep: MainStep.initializationIsNeeded(user: user))
            )
        )
    }
}

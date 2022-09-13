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
    
    private let userRepository: UserRepositoryProtocol
    private let compositionRepository: CompositionRepositoryProtocol
    
    init(
        userRepository: UserRepositoryProtocol,
        compositionRepository: CompositionRepositoryProtocol
    ) {
        self.userRepository = userRepository
        self.compositionRepository = compositionRepository
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? TadakStep else { return .none }
        
        switch step {
        case .onboardingIsRequired:
            return switchToOnboardingFlow()
            
        case .initializationIsRequired:
            return switchToMainFlow()
            
        default:
            return .none
        }
    }
}

private extension AppFlow {
    
    func switchToOnboardingFlow() -> FlowContributors {
        let onboardingFlow = OnboardingFlow(
            rootViewController: self.rootViewController,
            userRepository: self.userRepository,
            compositionRepository: self.compositionRepository
        )
        
        Flows.use(onboardingFlow, when: .created) { _ in }
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: onboardingFlow,
                withNextStepper: OneStepper(
                    withSingleStep: TadakStep.initializationIsRequired)
            )
        )
    }
    
    func switchToMainFlow() -> FlowContributors {
        let mainFlow = MainFlow(
            rootViewController: self.rootViewController,
            userRepository: self.userRepository,
            compositionRepository: self.compositionRepository
        )
        
        Flows.use(mainFlow, when: .created) { _ in }
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: mainFlow,
                withNextStepper: OneStepper(
                    withSingleStep: TadakStep.initializationIsRequired)
            )
        )
    }
}

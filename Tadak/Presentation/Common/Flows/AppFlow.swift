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
            return navigateToOnboardingScreen()
        }
    }
    
    private func navigateToOnboardingScreen() -> FlowContributors {
        let onboardingFlow = OnboardingFlow()
        
        Flows.use(onboardingFlow, when: .created) { [weak self] root in
            root.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.rootViewController.present(root, animated: false)
            }
        }
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: onboardingFlow,
                withNextStepper: OneStepper(
                    withSingleStep: OnboardingStep.newUserEntered)
            )
        )
    }
}

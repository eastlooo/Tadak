//
//  OnboardingFlow.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import RxFlow

final class OnboardingFlow: Flow {

    var root: Presentable { self.rootViewController }
    
    private lazy var rootViewController = NavigationController()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? OnboardingStep else { return .none }
        
        switch step {
        case .newUserEntered:
            return navigateToCharacterSelectScreen()
            
        case .onboardingCharacterSelected(let withCharacterID):
            return navigateToNicknameSettingScreen(with: withCharacterID)
            
        case .onboardingCharacterReselected:
            return popToCharacterSelectScreen()
        }
    }
    
    private func navigateToCharacterSelectScreen() -> FlowContributors {
        let useCase = OnboardingCharacterUseCase()
        let reactor = OnboardingCharacterViewReactor(useCase: useCase)
        let viewController = OnboardingCharacterViewController()
        viewController.reactor = reactor
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: reactor
            )
        )
    }
    
    private func navigateToNicknameSettingScreen(with characterID: Int) -> FlowContributors {
        let useCase = OnboardingNicknameUseCase(characterID: characterID)
        let reactor = OnboardingNicknameViewReactor(useCase: useCase)
        let viewController = OnboardingNicknameViewController()
        viewController.reactor = reactor
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: viewController
            )
        )
    }
    
    private func popToCharacterSelectScreen() -> FlowContributors {
        rootViewController.popToRootViewController(animated: false)
        return .none
    }
}



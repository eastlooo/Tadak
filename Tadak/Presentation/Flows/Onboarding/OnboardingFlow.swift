//
//  OnboardingFlow.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import UIKit
import RxFlow

final class OnboardingFlow: Flow {

    var root: Presentable { self.rootViewController }
    
    private let rootViewController: UINavigationController
    private let useCaseProvider: UseCaseProviderProtocol
    
    init(
        rootViewController: UINavigationController,
        useCaseProvider: UseCaseProviderProtocol
    ) {
        self.rootViewController = rootViewController
        self.useCaseProvider = useCaseProvider
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? TadakStep else { return .none }
        
        switch step {
        case .onboardingIsRequired:
            return navigateToCharacterSelectScreen()
            
        case .onboardingCharacterSelected(let withCharacterID):
            return navigateToNicknameSettingScreen(with: withCharacterID)
            
        case .onboardingCharacterReselected:
            return popToCharacterSelectScreen()
            
        case .nicknameDuplicated:
            return presentNicknameDupicatedAlert()
            
        case .onboardingIsComplete(let user):
            return switchToMainFlow(user: user)
            
        default:
            return .none
        }
    }
}

extension OnboardingFlow {
    private func navigateToCharacterSelectScreen() -> FlowContributors {
        let useCase = useCaseProvider.makeOnboardingUseCase()
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
        let useCase = useCaseProvider.makeOnboardingUseCase()
        let reactor = OnboardingNicknameViewReactor(characterID: characterID, useCase: useCase)
        let viewController = OnboardingNicknameViewController()
        viewController.reactor = reactor
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: reactor
            )
        )
    }
    
    private func popToCharacterSelectScreen() -> FlowContributors {
        rootViewController.popToRootViewController(animated: false)
        return .none
    }
    
    private func presentNicknameDupicatedAlert() -> FlowContributors {
        let message = "이미 사용 중인 별명이에요"
        let alert = AlertController()
        let alertAction = AlertAction(title: "확인", style: .default)
        alert.alertMessage = message
        alert.addAction(alertAction)
        alert.modalPresentationStyle = .overFullScreen
        self.rootViewController.present(alert, animated: false)
        return .none
    }
    
    private func switchToMainFlow(user: TadakUser) -> FlowContributors {
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



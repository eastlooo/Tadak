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
    private let userRepository: UserRepositoryProtocol
    private let compositionRepository: CompositionRepositoryProtocol
    
    init(
        rootViewController: UINavigationController,
        userRepository: UserRepositoryProtocol,
        compositionRepository: CompositionRepositoryProtocol
    ) {
        self.rootViewController = rootViewController
        self.userRepository = userRepository
        self.compositionRepository = compositionRepository
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
            
        case .onboardingIsComplete:
            return switchToMainFlow()
            
        default:
            return .none
        }
    }
}

extension OnboardingFlow {
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
        let useCase = OnboardingNicknameUseCase(
            characterID: characterID,
            userRepository: self.userRepository
        )
        let reactor = OnboardingNicknameViewReactor(useCase: useCase)
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
    
    private func switchToMainFlow() -> FlowContributors {
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



//
//  MainFlow.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import UIKit
import RxFlow

final class MainFlow: Flow {
    
    var root: Presentable { self.rootViewController }
    
    private let rootViewController: UINavigationController
    private let useCaseProvider: UseCaseProviderProtocol
    private let user: TadakUser
    
    init(
        rootViewController: UINavigationController,
        useCaseProvider: UseCaseProviderProtocol,
        user: TadakUser
    ) {
        self.rootViewController = rootViewController
        self.useCaseProvider = useCaseProvider
        self.user = user
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? TadakStep else { return .none }
        
        switch step {
        case .initializationIsRequired:
            return navigateToInitializationScreen()
            
        case .initializationIsComplete:
            return navigateToMainScreen()
            
        case .tadakListIsRequired:
            return navigateToTadakListScreen()
            
        case .myListIsRequired:
            return navigateToMyListScreen()
            
        case .listIsComplete, .settingsIsComplete:
            return dismissPresentedScreen()
            
        case .abused(let abuse):
            return dismissAndPresentAbuseAlert(abuse)
            
        case .settingsIsRequired(let user):
            return navigateToSettingScreen(user: user)
            
        case .onboardingIsRequired:
            return switchToOnboardingScreen()
            
        default:
            return .none
        }
    }
}

private extension MainFlow {
    
    func navigateToInitializationScreen() -> FlowContributors {
        let useCase = useCaseProvider.makeInitializationUseCase()
        let reactor = InitializationViewReactor(user: user, initializationUseCase: useCase)
        let viewController = InitializationViewController()
        viewController.reactor = reactor
        self.rootViewController.viewControllers = [viewController]
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: reactor
            )
        )
    }
    
    func navigateToMainScreen() -> FlowContributors {
        let reactor = TadakMainViewReactor(user: user)
        let viewController = TadakMainViewController()
        viewController.reactor = reactor
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: reactor
            )
        )
    }
    
    func navigateToTadakListScreen() -> FlowContributors {
        let tadakListFlow = TadakListFlow(useCaseProvider: useCaseProvider, user: user)
        
        Flows.use(tadakListFlow, when: .created) { root in
            root.modalPresentationStyle = .fullScreen
            self.rootViewController.present(root, animated: false)
        }
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: tadakListFlow,
                withNextStepper: OneStepper(
                    withSingleStep: TadakStep.tadakListIsRequired)
            )
        )
    }
    
    func dismissPresentedScreen() -> FlowContributors {
        if let viewController = self.rootViewController.presentedViewController {
            DispatchQueue.main.async {
                viewController.dismiss(animated: false)
            }
        }
        
        return .none
    }
    
    func navigateToMyListScreen() -> FlowContributors {
        let myListFlow = MyListFlow(useCaseProvider: useCaseProvider, user: user)
        
        Flows.use(myListFlow, when: .created) { root in
            root.modalPresentationStyle = .fullScreen
            self.rootViewController.present(root, animated: false)
        }
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: myListFlow,
                withNextStepper: OneStepper(
                    withSingleStep: TadakStep.myListIsRequired)
            )
        )
    }
    
    func dismissAndPresentAbuseAlert(_ abuse: Abuse) -> FlowContributors {
        let title = "알림"
        let message = abuse.alertMessage
        let alert = AlertController()
        let alertAction = AlertAction(title: "확인", style: .default)
        alert.alertTitle = title
        alert.alertMessage = message
        alert.addAction(alertAction)
        alert.modalPresentationStyle = .overFullScreen
        
        if let viewController = self.rootViewController.presentedViewController {
            DispatchQueue.main.async {
                viewController.dismiss(animated: false) {
                    self.rootViewController.present(alert, animated: false)
                }
            }
        }
        
        return .none
    }
    
    func navigateToSettingScreen(user: TadakUser) -> FlowContributors {
        let settingFlow = SettingFlow(useCaseProvider: useCaseProvider)
        
        Flows.use(settingFlow, when: .created) { root in
            root.modalPresentationStyle = .fullScreen
            self.rootViewController.present(root, animated: false)
        }
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: settingFlow,
                withNextStepper: OneStepper(
                    withSingleStep: TadakStep.settingsIsRequired(user: user))
            )
        )
    }
    
    func switchToOnboardingScreen() -> FlowContributors {
        if let viewController = self.rootViewController.presentedViewController {
            DispatchQueue.main.async {
                viewController.dismiss(animated: false)
            }
            rootViewController.viewControllers = []
        }
        
        return .end(forwardToParentFlowWithStep: TadakStep.onboardingIsRequired)
    }
}

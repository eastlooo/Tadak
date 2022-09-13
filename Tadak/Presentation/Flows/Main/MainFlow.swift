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
        case .initializationIsRequired:
            return navigateToInitializationScreen()
            
        case .initializationIsComplete:
            return navigateToMainScreen()
            
        case .tadakListIsRequired:
            return navigateToTadakListScreen()
            
        case .myCompositionIsRequired:
            return navigateToMyListScreen()
            
        case .tadakListIsComplete:
            return dismissTadakList()
            
        default:
            return .none
        }
    }
}

extension MainFlow {
    private func navigateToInitializationScreen() -> FlowContributors {
        let useCase = InitializationUseCase(
            userRepository: self.userRepository,
            compositionRepository: self.compositionRepository
        )
        let reactor = InitializationViewReactor(useCase: useCase)
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
    
    private func navigateToMainScreen() -> FlowContributors {
        let useCase = TadakMainUseCase(userRepository: userRepository)
        let reactor = TadakMainViewReactor(useCase: useCase)
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
    
    private func navigateToTadakListScreen() -> FlowContributors {
        let tadakListFlow = TadakListFlow(
            userRepository: self.userRepository,
            compositionRepository: self.compositionRepository
        )
        
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
    
    private func dismissTadakList() -> FlowContributors {
        if let tadakListViewController = self.rootViewController.presentedViewController {
            tadakListViewController.dismiss(animated: false)
        }
        
        return .none
    }
    
    private func navigateToMyListScreen() -> FlowContributors {
        return .none
    }
}

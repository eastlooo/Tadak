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
        guard let step = step as? MainStep else { return .none }
        
        switch step {
        case .initializationIsNeeded:
            return navigateToInitializationScreen()
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
        return .none
    }
}

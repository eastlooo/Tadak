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
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MainStep else { return .none }
        
        switch step {
        case .initializationIsNeeded(let user):
            return navigateToInitializationScreen(user: user)
        }
    }
}

extension MainFlow {
    private func navigateToInitializationScreen(user: TadakUser) -> FlowContributors {
        let viewController = InitializationViewController()
        self.rootViewController.viewControllers = [viewController]
        return .none
    }
}

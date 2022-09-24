//
//  MyListFlow.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/17.
//

import RxFlow

final class MyListFlow: Flow {
    
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
        case .myListIsRequired:
            return navigateToMyListScreen()
            
        case .myListIsComplete:
            return .end(
                forwardToParentFlowWithStep: TadakStep.myListIsComplete
            )
            
        case .makeCompositionIsRequired:
            return navigateToMakeCompositionScreen()
            
        case .compositionIsPicked(let typingDetail):
            return navigateToCompositionDetailScreen(typingDetail: typingDetail)
            
        case .makeCompositionIsComplete, .compositionDetailIsComplete:
            return popToRootScreen()
            
        case .typingIsRequired(let typingDetail):
            return navigateToTypingScreen(typingDetail: typingDetail)
            
        default:
            return .none
        }
    }
}

private extension MyListFlow {
    
    func navigateToMyListScreen() -> FlowContributors {
        let reactor = MyListViewReactor()
        let viewController = MyListViewController()
        viewController.reactor = reactor
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: reactor
            )
        )
    }
    
    func navigateToMakeCompositionScreen() -> FlowContributors {
        let reactor = MakeCompositionViewReactor()
        let viewController = MakeCompositionViewController()
        viewController.reactor = reactor
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: reactor
            )
        )
    }
    
    func navigateToCompositionDetailScreen(typingDetail: TypingDetail) -> FlowContributors {
        let reactor = CompositionDetailViewReactor(typingDetail: typingDetail)
        let viewController = CompositionDetailViewController()
        viewController.reactor = reactor
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: reactor
            )
        )
    }
    
    func popToRootScreen() -> FlowContributors {
        _ = rootViewController.popToRootViewController(animated: false)
        return .none
    }
    
    func navigateToTypingScreen(typingDetail: TypingDetail) -> FlowContributors {
        let typingFlow = TypingFlow(
            rootViewController: self.rootViewController,
            userRepository: self.userRepository,
            compositionRepository: self.compositionRepository
        )
        
        Flows.use(typingFlow, when: .created) { _ in }
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: typingFlow,
                withNextStepper: OneStepper(
                    withSingleStep: TadakStep.typingIsRequired(withTypingDetail: typingDetail))
            )
        )
    }
}

//
//  TadakListFlow.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/13.
//

import RxFlow

final class TadakListFlow: Flow {
    
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
        case .tadakListIsRequired:
            return navigateToTadakListScreen()
            
        case .tadakListIsComplete:
            return .end(
                forwardToParentFlowWithStep: TadakStep.tadakListIsComplete
            )
            
        case .compositionIsPicked(let typingDetail):
            return navigateToCompositionDetailScreen(typingDetail: typingDetail)
            
        case .compositionDetailIsComplete:
            return popToRootScreen()
            
        case .participantsAreRequired:
            return navigateToParticipantsScreen()
            
        case .participantsAreComplete:
            return popToRootScreen()
            
        case .typingIsRequired(let typingDetail):
            return navigateToTypingScreen(typingDetail: typingDetail)
            
        default:
            return .none
        }
    }
}

private extension TadakListFlow {
    
    func navigateToTadakListScreen() -> FlowContributors {
        let useCase = TadakListUseCase(compositionRepository: compositionRepository)
        let reactor = TadakListViewReactor(useCase: useCase)
        let viewController = TadakListViewController()
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
    
    func navigateToParticipantsScreen() -> FlowContributors {
        let useCase = ComposeParticipantsUseCase()
        let reactor = ComposeParticipantsViewReactor(useCase: useCase)
        let viewController = ComposeParticipantsViewController()
        viewController.reactor = reactor
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: reactor
            )
        )
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

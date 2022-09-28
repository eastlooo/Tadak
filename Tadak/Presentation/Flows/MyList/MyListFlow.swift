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
    private let useCaseProvider: UseCaseProviderProtocol
    
    init(
        useCaseProvider: UseCaseProviderProtocol
    ) {
        self.useCaseProvider = useCaseProvider
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? TadakStep else { return .none }
        
        switch step {
        case .myListIsRequired:
            return navigateToMyListScreen()
            
        case .listIsComplete:
            return .end(
                forwardToParentFlowWithStep: TadakStep.listIsComplete
            )
            
        case .makeCompositionIsRequired:
            return navigateToMakeCompositionScreen()
            
        case .compositionIsPicked(let typingDetail):
            return navigateToCompositionDetailScreen(typingDetail: typingDetail)
            
        case .makeCompositionIsComplete, .compositionDetailIsComplete, .participantsAreComplete:
            return popToRootScreen()
            
        case .participantsAreRequired(let typingDetail):
            return navigateToParticipantsScreen(typingDetail: typingDetail)
            
        case .typingIsRequired(let typingDetail):
            return navigateToTypingScreen(typingDetail: typingDetail)
            
        default:
            return .none
        }
    }
}

private extension MyListFlow {
    
    func navigateToMyListScreen() -> FlowContributors {
        let useCase = useCaseProvider.makeCompositionUseCase()
        let reactor = MyListViewReactor(useCase: useCase)
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
        let useCase = useCaseProvider.makeCreateCompositionUseCase()
        let reactor = MakeCompositionViewReactor(useCase: useCase)
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
    
    func navigateToParticipantsScreen(typingDetail: TypingDetail) -> FlowContributors {
        let useCase = ComposeParticipantsUseCase()
        let reactor = ComposeParticipantsViewReactor(
            typingDetail: typingDetail,
            useCase: useCase
        )
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
            rootViewController: rootViewController,
            useCaseProvider: useCaseProvider
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

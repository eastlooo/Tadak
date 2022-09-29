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
    private let useCaseProvider: UseCaseProviderProtocol
    
    init(
        useCaseProvider: UseCaseProviderProtocol
    ) {
        self.useCaseProvider = useCaseProvider
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? TadakStep else { return .none }
        
        switch step {
        case .tadakListIsRequired:
            return navigateToTadakListScreen()
            
        case .listIsComplete, .abused:
            return .end(forwardToParentFlowWithStep: step)
            
        case .tadakCompositionIsPicked(let typingDetail, let score):
            return navigateToCompositionDetailScreen(typingDetail: typingDetail,
                                                     score: score)
            
        case .compositionDetailIsComplete:
            return popToRootScreen()
            
        case .participantsAreRequired(let typingDetail):
            return navigateToParticipantsScreen(typingDetail: typingDetail)
            
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
        let comositionUseCase = useCaseProvider.makeCompositionUseCase()
        let recordUseCase = useCaseProvider.makeRecordUseCase()
        let reactor = TadakListViewReactor(
            compositionUseCase: comositionUseCase,
            recordUseCase: recordUseCase
        )
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
    
    func navigateToCompositionDetailScreen(typingDetail: TypingDetail, score: Int?) -> FlowContributors {
        let reactor = CompositionDetailViewReactor(typingDetail: typingDetail,
                                                   score: score)
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
                    withSingleStep: TadakStep.typingIsRequired(typingDetail: typingDetail))
            )
        )
    }
}

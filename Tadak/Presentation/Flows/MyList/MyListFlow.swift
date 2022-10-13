//
//  MyListFlow.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/17.
//

import RxFlow
import RxSwift

final class MyListFlow: Flow {
    
    var root: Presentable { self.rootViewController }
    
    private let rootViewController = NavigationController()
    private let useCaseProvider: UseCaseProviderProtocol
    private let user: TadakUser
    
    init(
        useCaseProvider: UseCaseProviderProtocol,
        user: TadakUser
    ) {
        self.useCaseProvider = useCaseProvider
        self.user = user
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
            
        case .myCompositionIsPicked(let typingDetail):
            return navigateToCompositionDetailScreen(typingDetail: typingDetail)
            
        case .makeCompositionIsComplete, .participantsAreComplete:
            return popToRootScreen()
            
        case .compositionDetailIsComplete:
            return dismissPresentedScreen()
            
        case .participantsAreRequired(let typingDetail):
            return navigateToParticipantsScreen(typingDetail: typingDetail)
            
        case .typingIsRequired(let typingDetail):
            return navigateToTypingScreen(typingDetail: typingDetail)
            
        default:
            return .none
        }
    }
    
    func adapt(step: Step) -> Single<Step> {
        guard let step = step as? TadakStep else { return .just(step) }
        
        switch step {
        case .typingIsRequired(let typingDetail):
            switch typingDetail.typingMode {
            case .betting: return .just(step)
            default: return dismissPresentedScreen(withStep: step)
            }
            
        case .participantsAreRequired:
            return dismissPresentedScreen(withStep: step)
            
        default: return .just(step)
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
        let compositionUseCase = useCaseProvider.makeCompositionUseCase()
        let reactor = MakeCompositionViewReactor(compositionUseCase: compositionUseCase)
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
        viewController.modalPresentationStyle = .overFullScreen
        self.rootViewController.present(viewController, animated: true)
        
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
            useCaseProvider: useCaseProvider,
            user: user
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
    
    func dismissPresentedScreen() -> FlowContributors {
        if let presentedViewController = rootViewController.presentedViewController {
            presentedViewController.dismiss(animated: true)
        }
        
        return .none
    }
}

private extension MyListFlow {
    
    func dismissPresentedScreen(withStep step: Step) -> Single<Step> {
        return Single.create { [weak self] single in
            if let presentedViewController = self?.rootViewController.presentedViewController {
                presentedViewController.dismiss(animated: true) {
                    single(.success(step))
                }
            }
            
            return Disposables.create()
        }
    }
}

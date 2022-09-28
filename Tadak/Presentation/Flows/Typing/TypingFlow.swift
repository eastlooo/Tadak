//
//  TypingFlow.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/14.
//

import UIKit
import RxFlow

final class TypingFlow: Flow {
    
    var root: Presentable { self.rootViewController }
    
    private let rootViewController: UINavigationController
    private let useCaseProvider: UseCaseProviderProtocol
    
    init(
        rootViewController: UINavigationController,
        useCaseProvider: UseCaseProviderProtocol
    ) {
        self.rootViewController = rootViewController
        self.useCaseProvider = useCaseProvider
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? TadakStep else { return .none }
        
        switch step {
        case .typingIsRequired(let typingDetail):
            switch typingDetail.typingMode {
            case .practice:
                let composition = typingDetail.composition
                return navigateToPracticeTypingScreen(composition: composition)
                
            case .official:
                let composition = typingDetail.composition
                return navigateToOfficialTypingScreen(composition: composition)
                
            case .betting:
                let composition = typingDetail.composition
                let participants = typingDetail.names
                return navigateToBettingTypingScreen(
                    composition: composition,
                    participants: participants
                )
            }
            
        case .typingIsComplete, .practiceResultIsComplete, .bettingResultIsComplete:
            return .end(
                forwardToParentFlowWithStep: TadakStep.listIsComplete
            )
            
        case .abused:
            return .end(
                forwardToParentFlowWithStep: step
            )
            
        case .practiceResultIsRequired(let practiceResult):
            return navigateToPracticeResultScreen(practiceResult: practiceResult)
            
        case .officialSuccessIsRequired(let record):
            return navigateToOfficialSuccessScreen(record: record)
            
        case .officialFailureIsRequired(let typingSpeed):
            return navigateToOfficialFailureScreen(typingSpeed: typingSpeed)
            
        case .bettingResultIsRequired(let ranking):
            return navigateToBettingResultScreen(ranking: ranking)
            
        case .typingIsRequiredAgain:
            return popCurrentScreen()
            
        default:
            return .none
        }
    }
}

private extension TypingFlow {
    
    func navigateToPracticeTypingScreen(composition: Composition) -> FlowContributors {
        let useCase = useCaseProvider.makeTypingUseCase(composition: composition)
        let reactor = PracticeTypingViewReactor(useCase: useCase)
        let viewController = PracticeTypingViewController()
        viewController.reactor = reactor
        self.rootViewController.viewControllers = [viewController]
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: reactor
            )
        )
    }
    
    func navigateToOfficialTypingScreen(composition: Composition) -> FlowContributors {
        let useCase = useCaseProvider.makeTypingUseCase(composition: composition)
        let reactor = OfficialTypingViewReactor(useCase: useCase)
        let viewController = OfficialTypingViewController()
        viewController.reactor = reactor
        self.rootViewController.viewControllers = [viewController]
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: reactor
            )
        )
    }
    
    func navigateToBettingTypingScreen(composition: Composition, participants: [String]) -> FlowContributors {
        let typingseCase = useCaseProvider.makeTypingUseCase(composition: composition)
        let recordUseCase = useCaseProvider.makeBettingRecordUseCase(participants: participants)
        let reactor = BettingTypingViewReactor(
            typingUseCase: typingseCase,
            recordUseCase: recordUseCase)
        let viewController = BettingTypingViewController()
        viewController.reactor = reactor
        self.rootViewController.viewControllers = [viewController]
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: reactor
            )
        )
    }
    
    func navigateToPracticeResultScreen(practiceResult: PracticeResult) -> FlowContributors {
        let reactor = PracticeResultViewReactor(practiceResult: practiceResult)
        let viewController = PracticeResultViewController()
        viewController.reactor = reactor
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: reactor
            )
        )
    }
    
    func navigateToOfficialSuccessScreen(record: Record) -> FlowContributors {
        let recordUseCase = useCaseProvider.makeRecorduseCase()
        let reactor = OfficialSuccessViewReactor(record: record,
                                                 recordUseCase: recordUseCase)
        let viewController = OfficialSuccessViewController()
        viewController.reactor = reactor
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: reactor
            )
        )
    }
    
    func navigateToOfficialFailureScreen(typingSpeed: Int) -> FlowContributors {
        let reactor = OfficialFailureViewReactor(tyingSpeed: typingSpeed)
        let viewController = OfficialFailureViewController()
        viewController.reactor = reactor
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: reactor
            )
        )
    }
    
    func navigateToBettingResultScreen(ranking: [Rank]) -> FlowContributors {
        let reactor = BettingResultViewReactor(ranking: ranking)
        let viewController = BettingResultViewController()
        viewController.reactor = reactor
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: reactor
            )
        )
    }
    
    func popCurrentScreen() -> FlowContributors {
        self.rootViewController.popViewController(animated: false)
        return .none
    }
}

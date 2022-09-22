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
        case .typingIsRequired(let typingDetail):
            switch typingDetail.typingMode {
            case .practice:
                let composition = typingDetail.composition
                return navigateToPracticeTypingScreen(composition: composition)
                
            case .betting:
                let composition = typingDetail.composition
                let participants = typingDetail.names
                return navigateToBettingTypingScreen(composition: composition,
                                                     participants: participants)
                
            default:
                return .none
            }
            
        case .typingIsComplete:
            return .end(
                forwardToParentFlowWithStep: TadakStep.tadakListIsComplete
            )
            
        default:
            return .none
        }
    }
}

private extension TypingFlow {
    
    func navigateToPracticeTypingScreen(composition: Composition) -> FlowContributors {
        let useCase = TypingUseCase(composition: composition)
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
    
    func navigateToBettingTypingScreen(composition: Composition, participants: [String]) -> FlowContributors {
        let typingseCase = TypingUseCase(composition: composition)
        let recordUseCase = BettingRecordUseCase(participants: participants)
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
}

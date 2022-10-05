//
//  AppFlow.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import UIKit
import RxFlow

final class AppFlow: Flow {
    
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
        case .onboardingIsRequired:
            return switchToOnboardingFlow()
            
        case .initializationIsRequired(let user):
            return switchToMainFlow(user: user)
            
        case .networkIsDisconnected:
            return showNetworkConnectionAlert()
            
        default:
            return .none
        }
    }
}

private extension AppFlow {
    
    func switchToOnboardingFlow() -> FlowContributors {
        let onboardingFlow = OnboardingFlow(
            rootViewController: rootViewController,
            useCaseProvider: useCaseProvider
        )
        
        Flows.use(onboardingFlow, when: .created) { _ in }
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: onboardingFlow,
                withNextStepper: OneStepper(
                    withSingleStep: TadakStep.onboardingIsRequired)
            )
        )
    }
    
    func switchToMainFlow(user: TadakUser) -> FlowContributors {
        let mainFlow = MainFlow(
            rootViewController: rootViewController,
            useCaseProvider: useCaseProvider
        )
        
        Flows.use(mainFlow, when: .created) { _ in }
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: mainFlow,
                withNextStepper: OneStepper(
                    withSingleStep: TadakStep.initializationIsRequired(user: user))
            )
        )
    }
    
    func showNetworkConnectionAlert() -> FlowContributors {
        let title = "연결 실패"
        let message = "네트워크 연결 후\n앱을 다시 실행해주세요"
        let alert = AlertController()
        let alertAction = AlertAction(title: "종료", style: .default) { _ in
            // 강제 종료
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { exit(0) }
        }
        
        alert.alertTitle = title
        alert.alertMessage = message
        alert.addAction(alertAction)
        
        self.rootViewController.viewControllers = [alert]
        
        return .none
    }
}

//
//  SettingFlow.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/29.
//

import RxFlow
import MessageUI

final class SettingFlow: Flow {
    
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
        case .settingsIsRequired(let user):
            return navigateToSettingsScreen(user: user)
            
        case .settingsIsComplete, .onboardingIsRequired:
            return .end(forwardToParentFlowWithStep: step)
            
        case .contactMailIsRequired:
            return presentToSendMailScreen()
            
        case .mailDisableAlertIsRequired:
            return presentMailDisableAlert()
            
        case .resetAlertIsRequired:
            return presentResetAlertScreen()
            
        case .resetAlertIsComplete:
            return dismissPresentedScreen()
            
        case .resetIsRequired:
            return delegateResetToSettingScreen()
            
        default:
            return .none
        }
    }
}

private extension SettingFlow {
    
    func navigateToSettingsScreen(user: TadakUser) -> FlowContributors {
        let settingUseCase = useCaseProvider.makeSettingUseCase()
        let reactor = SettingViewReactor(user: user, settingUseCase: settingUseCase)
        let viewController = SettingViewController()
        viewController.reactor = reactor
        
        self.rootViewController.pushViewController(viewController, animated: false)
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: reactor
            )
        )
    }
    
    func presentToSendMailScreen() -> FlowContributors {
        if let visibleViewController = rootViewController.visibleViewController as? SettingViewController {
            let viewController = ContactMailViewController()
            viewController.mailComposeDelegate = visibleViewController
            
            visibleViewController.present(viewController, animated: true)
        }
        
        return .none
    }
    
    func presentMailDisableAlert() -> FlowContributors {
        let title = "알림"
        let message = "해당 기기에서 Mail 앱을\n실행할 수 없어요\n\nnupic7@gmail.com\n으로 문의해주세요"
        let alert = AlertController()
        let cancelAction = AlertAction(title: "닫기", style: .cancel)
        let defaultAction = AlertAction(title: "메일 복사하기", style: .default) { _ in
            UIPasteboard.general.string = "nupic7@gmail.com"
        }
        alert.alertTitle = title
        alert.alertMessage = message
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        alert.modalPresentationStyle = .overFullScreen
        
        self.rootViewController.present(alert, animated: false)
        
        return .none
    }
    
    func presentResetAlertScreen() -> FlowContributors {
        let reactor = ResetAlertReactor()
        let alert = ResetAlertController()
        alert.reactor = reactor
        alert.modalPresentationStyle = .overFullScreen
        
        self.rootViewController.present(alert, animated: false)
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: alert,
                withNextStepper: reactor
            )
        )
    }
    
    func delegateResetToSettingScreen() -> FlowContributors {
        if let presentedViewController = self.rootViewController.presentedViewController {
            presentedViewController.dismiss(animated: false)
        }
        
        if let settingViewController = self.rootViewController.viewControllers.last as? SettingViewController {
            settingViewController.resetAllData()
        }
        
        return .none
    }
    
    func dismissPresentedScreen() -> FlowContributors {
        if let presentedViewController = self.rootViewController.presentedViewController {
            presentedViewController.dismiss(animated: false)
        }
        
        return .none
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
    }
}

//
//  AppDelegate.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/04.
//

import UIKit
import RxSwift
import RxFlow
import FirebaseCore
import GoogleMobileAds

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let disposeBag = DisposeBag()
    var coordinator = FlowCoordinator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        AnalyticsManager.register([FirebaseAnalyticsProvider()])
        NetworkConnectionManager.startMonitoring()
        AppReviewManager.increaseSessionCount()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        self.coordinator.rx.didNavigate
            .subscribe(onNext: { flow, step in
                print("DEBUG: did navigate to flow=\(flow) and step=\(step)")
            })
            .disposed(by: disposeBag)

        let repositoryProvider = RepositoryProvider()
        let useCaseProvider = UseCaseProvider(repositoryProvider: repositoryProvider)
        let appFlow = AppFlow(useCaseProvider: useCaseProvider)

        let appStepper = AppStepper(useCaseProvider: useCaseProvider)
        self.coordinator.coordinate(flow: appFlow, with: appStepper)

        Flows.use(appFlow, when: .created) { root in
            window.rootViewController = root
            window.makeKeyAndVisible()
        }
        
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

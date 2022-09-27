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

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let disposeBag = DisposeBag()
    var coordinator = FlowCoordinator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        AnalyticsManager.register([FirebaseAnalyticsProvider()])
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        self.coordinator.rx.didNavigate
            .subscribe(onNext: { flow, step in
                print("DEBUG: did navigate to flow=\(flow) and step=\(step)")
            })
            .disposed(by: disposeBag)

        let userRepository = UserRepository()
        let compositionRepository = CompositionRepository()
        let appFlow = AppFlow(
            userRepository: userRepository,
            compositionRepository: compositionRepository
        )

        let appStepper = AppStepper(userRepository: userRepository)
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

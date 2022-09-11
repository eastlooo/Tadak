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
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        self.coordinator.rx.willNavigate.subscribe(onNext: { flow, step in
            print("DEBUG: will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: disposeBag)

        self.coordinator.rx.didNavigate.subscribe(onNext: { flow, step in
            print("DEBUG: did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: disposeBag)

        let appFlow = AppFlow()
        let appStepper = AppStepper()
        self.coordinator.coordinate(flow: appFlow, with: appStepper)

        Flows.use(appFlow, when: .created) { root in
            window.rootViewController = root
            window.makeKeyAndVisible()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

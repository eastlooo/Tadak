//
//  AppStepper.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import Foundation
import RxSwift
import RxRelay
import RxFlow

final class AppStepper: Stepper {
    
    let steps = PublishRelay<Step>()
    
    private let disposeBog = DisposeBag()

    private let useCaseProvider: UseCaseProviderProtocol
    
    init(useCaseProvider: UseCaseProviderProtocol) {
        self.useCaseProvider = useCaseProvider
    }

    func readyToEmitSteps() {
        let networkConnection = NetworkConnectionManager.checkConnection()
        let initializeUseCase = useCaseProvider.makeInitializationUseCase()
        
        if networkConnection {
            initializeUseCase.fetchUser()
                .map { user -> TadakStep in
                    guard let user = user else {
                        return .onboardingIsRequired
                    }
                    
                    return .initializationIsRequired(user: user)
                }
                .take(1)
                .bind(to: self.steps)
                .disposed(by: disposeBog)
        } else {
            steps.accept(TadakStep.networkIsDisconnected)
        }
    }
}

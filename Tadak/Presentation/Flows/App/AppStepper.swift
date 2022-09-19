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

    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    func readyToEmitSteps() {
        userRepository.fetchUser()
            .retry(2)
            .catchAndReturn(nil)
            .map { user -> TadakStep in
                if let _ = user { return .initializationIsRequired }
                return .onboardingIsRequired
            }
            .take(1)
            .bind(to: self.steps)
            .disposed(by: disposeBog)
    }
}

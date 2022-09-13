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
            .take(1)
            .map { result -> TadakUser? in
                switch result {
                case .success(let user): return user
                case .failure: return nil }
            }
            .map { user -> TadakStep in
                if let _ = user { return .initializationIsRequired }
                return .onboardingIsRequired
            }
            .bind(to: self.steps)
            .disposed(by: disposeBog)
    }
}

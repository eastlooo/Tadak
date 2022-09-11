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
    
    private let storage: Storage
    
    init(storage: Storage = try! RealmStorage()) {
        self.storage = storage
    }

    func readyToEmitSteps() {
        storage.fetch(TadakUserObject.self, predicate: nil, sorted: nil)
            .take(1)
            .map(\.first)
            .map { $0?.toDomain() }
            .map { user -> AppStep in
                if let user = user { return .userIsRegisterd(user: user) }
                return .onboardingIsRequired
            }
            .bind(to: self.steps)
            .disposed(by: disposeBog)
    }
}

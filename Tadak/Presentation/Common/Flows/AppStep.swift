//
//  AppStep.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import RxFlow

enum AppStep: Step {
    case onboardingIsRequired
    case userIsRegisterd(user: TadakUser)
}

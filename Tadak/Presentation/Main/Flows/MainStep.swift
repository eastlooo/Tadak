//
//  MainStep.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import RxFlow

enum MainStep: Step {
    case initializationIsNeeded(user: TadakUser)
}

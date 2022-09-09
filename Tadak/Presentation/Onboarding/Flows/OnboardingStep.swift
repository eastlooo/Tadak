//
//  OnboardingStep.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import RxFlow

enum OnboardingStep: Step {
    case newUserEntered
    case onboardingCharacterSelected(withCharacterID: Int)
    case onboardingCharacterReselected
}

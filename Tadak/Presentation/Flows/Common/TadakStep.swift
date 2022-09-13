//
//  TadakStep.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/13.
//

import RxFlow

enum TadakStep: Step {
    
    // Global
//    case userIsRegisterd(user: TadakUser)
    
    // Onboarding
    case onboardingIsRequired
    case onboardingCharacterSelected(withCharacterID: Int)
    case onboardingCharacterReselected
    case nicknameDuplicated
    case onboardingIsComplete
    
    // Main
    case initializationIsRequired
    case initializationIsComplete
    
    // TadakList
    case tadakListIsRequired
    case tadakListIsComplete
    
    // MyList
    case myCompositionIsRequired
    
    // CompositionDetail
    case compositionIsPicked(withTypingDetail: TypingDetail)
}

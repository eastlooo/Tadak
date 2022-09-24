//
//  TadakStep.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/13.
//

import RxFlow

enum TadakStep: Step {
    
    // Global
    
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
    case myListIsRequired
    case myListIsComplete
    
    // MakeComposition
    case makeCompositionIsRequired
    case makeCompositionIsComplete
    
    // CompositionDetail
    case compositionIsPicked(withTypingDetail: TypingDetail)
    case compositionDetailIsComplete
    
    case participantsAreRequired(withTypingDetail: TypingDetail)
    case participantsAreComplete
    
    // Typing
    case typingIsRequired(withTypingDetail: TypingDetail)
    case typingIsComplete
    
    // Result
    case practiceResultIsRequired(withPracticeResult: PracticeResult)
    case practiceResultIsComplete
    case bettingResultIsRequired(withRanking: [Rank])
    case bettingResultIsComplete
}

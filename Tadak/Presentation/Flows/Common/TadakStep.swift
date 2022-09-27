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
    
    // List
    case tadakListIsRequired
    case myListIsRequired
    case listIsComplete
    
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
    case abused(withAbuse: Abuse)
    
    // Result
    case practiceResultIsRequired(withPracticeResult: PracticeResult)
    case practiceResultIsComplete
    case bettingResultIsRequired(withRanking: [Rank])
    case bettingResultIsComplete
    case officialSuccessIsRequired(withTypingSpeed: Int)
    case officialFailureIsRequired(withTypingSpeed: Int)
    
    case typingIsRequiredAgain
}

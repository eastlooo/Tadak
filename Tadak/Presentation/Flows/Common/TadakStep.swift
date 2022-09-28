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
    case onboardingCharacterSelected(characterID: Int)
    case onboardingCharacterReselected
    case nicknameDuplicated
    case onboardingIsComplete(user: TadakUser)
    
    // Main
    case initializationIsRequired(user: TadakUser)
    case initializationIsComplete(user: TadakUser)
    
    // List
    case tadakListIsRequired
    case myListIsRequired
    case listIsComplete
    
    // MakeComposition
    case makeCompositionIsRequired
    case makeCompositionIsComplete
    
    // CompositionDetail
    case myCompositionIsPicked(typingDetail: TypingDetail)
    case tadakCompositionIsPicked(typingDetail: TypingDetail, score: Int?)
    case compositionDetailIsComplete
    
    // Participants
    case participantsAreRequired(typingDetail: TypingDetail)
    case participantsAreComplete
    
    // Typing
    case typingIsRequired(typingDetail: TypingDetail)
    case typingIsComplete
    case abused(abuse: Abuse)
    
    // Result
    case practiceResultIsRequired(practiceResult: PracticeResult)
    case practiceResultIsComplete
    case bettingResultIsRequired(ranking: [Rank])
    case bettingResultIsComplete
    case officialSuccessIsRequired(record: Record)
    case officialFailureIsRequired(typingSpeed: Int)
    case typingIsRequiredAgain
}

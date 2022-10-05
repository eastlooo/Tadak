//
//  TadakStep.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/13.
//

import RxFlow

enum TadakStep: Step {
    
    // Global
    case networkIsDisconnected
    
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
    case bettingResultIsRequired(composition: any Composition, ranking: [Rank])
    case bettingResultIsComplete
    case officialSuccessIsRequired(title: String, record: Record)
    case officialFailureIsRequired(typingSpeed: Int)
    case typingIsRequiredAgain
    case shareResultIsRequired(title: String, score: Int)
    
    // Setting
    case settingsIsRequired(user: TadakUser)
    case settingsIsComplete
    case contactMailIsRequired
    case mailDisableAlertIsRequired
    case resetAlertIsRequired
    case resetAlertIsComplete
    case resetIsRequired
}

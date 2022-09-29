//
//  UseCaseProviderProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/28.
//

import Foundation

protocol UseCaseProviderProtocol {
    
    func makeOnboardingUseCase() -> OnboardingUseCaseProtocol
    func makeInitializationUseCase() -> InitializationUseCaseProtocol
    func makeCompositionUseCase() -> CompositionUseCaseProtocol
    func makeComposeParticipantsUseCase() -> ComposeParticipantsUseCaseProtocol
    func makeTypingUseCase(composition: any Composition) -> TypingUseCaseProtocol
    func makeBettingRecordUseCase(participants: [String]) -> BettingRecordUseCaseProtocol
    func makeRecordUseCase() -> RecordUseCaseProtocol
    func makeSettingUseCase() -> SettingUseCaseProtocol
}

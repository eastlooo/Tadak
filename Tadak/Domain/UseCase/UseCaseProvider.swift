//
//  UseCaseProvider.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/28.
//

import Foundation

final class UseCaseProvider: UseCaseProviderProtocol {
    
    private let userRepository: UserRepositoryProtocol
    private let compositionRepository: CompositionRepositoryProtocol
    private let recordRepository: RecordRepositoryProtocol
    
    init(repositoryProvider: RepositoryProviderProtocol) {
        self.userRepository = repositoryProvider.makeUserRepository()
        self.compositionRepository = repositoryProvider.makeCompositionRepository()
        self.recordRepository = repositoryProvider.makeRecordRepository()
    }
}

extension UseCaseProvider {
    
    func makeOnboardingUseCase() -> OnboardingUseCaseProtocol {
        return OnboardingUseCase(userRepository: userRepository)
    }
    
    func makeInitializationUseCase() -> InitializationUseCaseProtocol {
        return InitializationUseCase(
            userRepository: userRepository,
            compositionRepository: compositionRepository,
            recordRepository: recordRepository
        )
    }
    
    func makeCompositionUseCase() -> CompositionUseCaseProtocol {
        return CompositionUseCase(compositionRepository: compositionRepository)
    }
    
    func makeComposeParticipantsUseCase() -> ComposeParticipantsUseCaseProtocol {
        return ComposeParticipantsUseCase()
    }
    
    func makeTypingUseCase(composition: any Composition) -> TypingUseCaseProtocol {
        return TypingUseCase(composition: composition)
    }
    
    func makeBettingRecordUseCase(participants: [String]) -> BettingRecordUseCaseProtocol {
        return BettingRecordUseCase(participants: participants)
    }
    
    func makeRecorduseCase() -> RecordUseCaseProtocol {
        return RecordUseCase(recordRepository: recordRepository)
    }
}

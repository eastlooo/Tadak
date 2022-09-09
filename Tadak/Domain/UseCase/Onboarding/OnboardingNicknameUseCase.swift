//
//  OnboardingNicknameUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import Foundation
import RxSwift

protocol OnboardingNicknameUseCaseProtocol: AnyObject {
    
    var characterID: Int { get }
    
    func checkValidate(_ text: String) -> Bool
    func correctText(_ text: String) -> String
    func register() -> Observable<Result<Void, Error>>
}

final class OnboardingNicknameUseCase {
    
    private let minLength: Int = 2
    private let maxLength: Int = 6
    
    let characterID: Int
    var nickname: String = ""
    
    private let firebaseDatabaseRepository: FirebaseDatabaseRepositoryProtocol
    
    init(
        characterID: Int,
        firebaseDatabaseRepository: FirebaseDatabaseRepositoryProtocol = FirebaseDatabaseRepository()
    ) {
        self.characterID = characterID
        self.firebaseDatabaseRepository = firebaseDatabaseRepository
    }
}

extension OnboardingNicknameUseCase: OnboardingNicknameUseCaseProtocol {
    
    func checkValidate(_ text: String) -> Bool {
        text.count >= minLength && text.count <= maxLength
    }
    
    func correctText(_ text: String) -> String {
        let text = text.trimmingCharacters(in: .whitespaces)
        guard text.count > maxLength else {
            self.nickname = text
            return text
        }
        
        let startIndex = text.startIndex
        let endIndex = text.index(startIndex, offsetBy: maxLength)
        let correctedText = String(text[..<endIndex])
        self.nickname = correctedText
        return correctedText
    }
    
    func register() -> Observable<Result<Void, Error>> {
        let uid = UUID().uuidString
        return firebaseDatabaseRepository.registerUser(
            uid: uid,
            nickname: nickname,
            characterID: characterID
        )
    }
}

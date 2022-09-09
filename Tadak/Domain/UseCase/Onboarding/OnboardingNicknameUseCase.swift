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
    
    func checkNicknameDuplication() -> Observable<Result<Bool, Error>>
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
    
    func checkNicknameDuplication() -> Observable<Result<Bool, Error>> {
        return firebaseDatabaseRepository.checkNicknameDuplication(nickname: nickname)
            .map { result -> Result<Bool, Error> in
                switch result {
                case .success:
                    return .success(true)
                    
                case .failure(let error):
                    if let error = error as? FirebaseError, error == .emptyResult {
                        return .success(false)
                    } else {
                        return .failure(error)
                    }
                }
            }
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

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
    func startOnboardingFlow() -> Observable<Result<Void, Error>>
}

final class OnboardingNicknameUseCase {
    
    private let minLength: Int = 2
    private let maxLength: Int = 6
    
    let characterID: Int
    var nickname: String = ""
    
    private let userRepository: UserRepositoryProtocol
    
    init(
        characterID: Int,
        userRepository: UserRepositoryProtocol = UserRepository()
    ) {
        self.characterID = characterID
        self.userRepository = userRepository
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
        return userRepository.checkNicknameDuplication(nickname: nickname)
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
    
    func startOnboardingFlow() -> Observable<Result<Void, Error>> {
        let uid = UUID().uuidString
        
        // 서버에 유저 저장
        return userRepository.createUserOnServer(
            uid: uid,
            nickname: nickname,
            characterID: characterID
        )
        // 성공 시 로컬에 유저 저장
            .flatMap { [weak self] result -> Observable<Result<Void, Error>> in
                guard let self = self else { return .just(.failure(NSError()))}
                switch result {
                case .success:
                    return self.userRepository.saveUserOnStorage(
                        uid: uid,
                        nickname: self.nickname,
                        characterID: self.characterID
                    )

                case .failure(let error):
                    return .just(.failure(error))
                }
            }
        // 실패 시 서버에 유저 삭제
            .flatMap { [weak self] result -> Observable<Result<Void, Error>> in
                guard let self = self else { return .just(.failure(NSError()))}
                switch result {
                case .success(let value):
                    return .just(.success(value))

                case .failure:
                    return self.userRepository.deleteUserOnServer(
                        uid: uid,
                        nickname: self.nickname
                    )
                }
            }
    }
}

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
    var maxLength: Int { get }
    
    func checkValidate(_ text: String) -> Bool
    func correctText(_ text: String) -> String
    
    func checkNicknameDuplication() -> Observable<Bool>
    func startOnboardingFlow() -> Observable<TadakUser>
}

final class OnboardingNicknameUseCase {
    
    let minLength: Int = 2
    let maxLength: Int = 6
    
    let characterID: Int
    var nickname: String = ""
    
    private let userRepository: UserRepositoryProtocol
    
    init(
        characterID: Int,
        userRepository: UserRepositoryProtocol
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
    
    func checkNicknameDuplication() -> Observable<Bool> {
        return userRepository.checkNickname(nickname: nickname)
            .map { _ in true }
            .catch { error -> Observable<Bool> in
                if let error = error as? FirebaseError, error == .emptyResult {
                    return .just(false)
                } else {
                    return .error(error)
                }
            }
            .retry()
    }
    
    func startOnboardingFlow() -> Observable<TadakUser> {
        
        lazy var uid = ""
        let nickname = self.nickname
        let characterID = self.characterID
        let repository = self.userRepository
        
        // 익명 가입
        return repository.signInUserAnonymously()
        // 성공 시 유저 서버 및 로컬에 저장
            .do { uid = $0 }
            .map { ($0, nickname, characterID) }
            .flatMap(repository.createUser)
            .retry()
        // 실패 시 유저 가입, 서버 및 로컬 삭제
            .catch { error -> Observable<TadakUser> in
                return repository.deleteUser(uid: uid, nickname: nickname)
                    .map { _ in
                        return TadakUser(
                            id: uid,
                            nickname: nickname,
                            characterID: characterID
                        )
                    }
                    .retry()
            }
    }
}

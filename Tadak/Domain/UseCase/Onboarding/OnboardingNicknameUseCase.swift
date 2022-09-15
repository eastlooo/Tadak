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
    
    func checkNicknameDuplication() -> Observable<Result<Bool, Error>>
    func startOnboardingFlow() -> Observable<Result<TadakUser, Error>>
}

final class OnboardingNicknameUseCase {
    
    var minLength: Int { 2 }
    var maxLength: Int { 6 }
    
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
    
    func startOnboardingFlow() -> Observable<Result<TadakUser, Error>> {
        
        var userId = ""
        let nickname = self.nickname
        let characterID = self.characterID
        
        // 익명 가입
        return userRepository.signInUserAnonymously()
        // 성공 시 유저 서버 및 로컬에 저장
            .flatMapOnSuccess { [weak self] uid -> Observable<Result<Void, Error>> in
                userId = uid
                guard let self = self else { return .empty() }
                return self.userRepository.createUser(
                    uid: uid,
                    nickname: nickname,
                    characterID: characterID
                )
            }
        // 실패 시 유저 가입, 서버 및 로컬 삭제
            .doAnotherOnFailure { [weak self] () -> Observable<Result<Void, Error>> in
                guard let self = self else { return .empty() }
                return self.userRepository.deleteUser(uid: userId, nickname: nickname)
            }
        // 유저 데이터 리턴
            .mapOnSuccess { _ -> TadakUser in
                return .init(id: userId, nickname: nickname, characterID: characterID)
            }
    }
}

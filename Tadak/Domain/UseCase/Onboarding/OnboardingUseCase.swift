//
//  OnboardingUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import Foundation
import RxSwift

final class OnboardingUseCase: OnboardingUseCaseProtocol {
    
    let characterIDs: [Int]
    let nicknameMinLength: Int = 2
    let nicknameMaxLength: Int = 6
    
    var characterID: Int?
    var nickname: String = ""
    
    private let userRepository: UserRepositoryProtocol
    
    init(
        userRepository: UserRepositoryProtocol
    ) {
        self.characterIDs = (1...20).shuffled().shuffled().shuffled().map { $0 }
        self.userRepository = userRepository
    }
}

extension OnboardingUseCase {
    
    func getCharacterId(at index: Int) -> Int {
        characterIDs[index]
    }
    
    func checkValidate(_ text: String) -> Bool {
        text.count >= nicknameMinLength && text.count <= nicknameMaxLength
    }
    
    func correctText(_ text: String) -> String {
        let text = text.trimmingCharacters(in: .whitespaces)
        guard text.count > nicknameMaxLength else {
            self.nickname = text
            return text
        }
        
        let startIndex = text.startIndex
        let endIndex = text.index(startIndex, offsetBy: nicknameMaxLength)
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
        
        guard let characterID = self.characterID else { return .error(NSError())}
        lazy var uid = ""
        let nickname = self.nickname
        let repository = self.userRepository
        
        // 익명 가입
        return repository.signInUserAnonymously()
        // 성공 시 유저 서버 및 로컬에 저장
            .do { uid = $0 }
            .map { ($0, nickname, characterID) }
            .flatMap(repository.createUser)
            .do { user in
                AnalyticsManager.setUserID(user.id)
                AnalyticsManager.log(
                    UserEvent.register(nickname: nickname, characterID: characterID)
                )
            }
            .retry(2)
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
                    .retry(2)
            }
    }
}

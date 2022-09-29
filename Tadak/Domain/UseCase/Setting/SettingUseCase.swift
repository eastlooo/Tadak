//
//  SettingUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/29.
//

import Foundation
import RxSwift
import MessageUI

final class SettingUseCase: SettingUseCaseProtocol {
    
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
}

extension SettingUseCase {
    
    func reset(user: TadakUser) -> Observable<Void> {
        return userRepository.deleteUser(uid: user.id, nickname: user.nickname).retry(3)
    }
    
    func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
}

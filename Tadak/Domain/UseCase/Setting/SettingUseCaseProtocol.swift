//
//  SettingUseCaseProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/29.
//

import Foundation
import RxSwift

protocol SettingUseCaseProtocol {
    
    func reset(user: TadakUser) -> Observable<Void>
    func canSendMail() -> Bool
}

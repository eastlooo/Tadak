//
//  OnboardingUseCaseProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/27.
//

import Foundation
import RxSwift

protocol OnboardingUseCaseProtocol: AnyObject {
    
    var characterIDs: [Int] { get }
    var characterID: Int? { get set }
    var nicknameMaxLength: Int { get }
    
    func getCharacterId(at index: Int) -> Int
    
    func checkValidate(_ text: String) -> Bool
    func correctText(_ text: String) -> String
    
    func checkNicknameDuplication() -> Observable<Bool>
    func startOnboardingFlow() -> Observable<TadakUser>
}

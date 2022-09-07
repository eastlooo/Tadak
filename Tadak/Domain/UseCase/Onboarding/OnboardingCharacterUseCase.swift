//
//  OnboardingCharacterUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/07.
//

import Foundation

protocol OnboardingCharacterUseCaseProtocol: AnyObject {
    
    var characterIDs: [Int] { get }
    
    func findCharacterID(index: Int) -> Int
}

final class OnboardingCharacterUseCase: OnboardingCharacterUseCaseProtocol {
    
    let characterIDs = (1...20).shuffled().shuffled().shuffled().map { $0 }
    
    func findCharacterID(index: Int) -> Int {
        characterIDs[index]
    }
}

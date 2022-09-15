//
//  PracticeTypingUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/14.
//

import Foundation

protocol PracticeTypingUseCaseProtocol: AnyObject {
    
    var composition: Composition { get }
}

final class PracticeTypingUseCase {
    
    var composition: Composition { _composition }
    
    private let _composition: Composition
    
    init(composition: Composition) {
        self._composition = composition
    }
}

extension PracticeTypingUseCase: PracticeTypingUseCaseProtocol {}

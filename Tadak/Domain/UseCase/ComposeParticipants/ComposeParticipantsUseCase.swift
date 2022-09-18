//
//  ComposeParticipantsUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/18.
//

import Foundation
import RxSwift

protocol ComposeParticipantsUseCaseProtocol: AnyObject {
    
    var minimumNumber: Int { get }
    var maximumNumber: Int { get }
}

final class ComposeParticipantsUseCase {
    
    let minimumNumber: Int = 2
    let maximumNumber: Int = 8
}

extension ComposeParticipantsUseCase: ComposeParticipantsUseCaseProtocol {}

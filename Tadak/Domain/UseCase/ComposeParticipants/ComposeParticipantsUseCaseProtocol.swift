//
//  ComposeParticipantsUseCaseProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/28.
//

import Foundation
import RxSwift

protocol ComposeParticipantsUseCaseProtocol: AnyObject {
    
    var minNumber: Observable<Int> { get }
    var maxNumber: Observable<Int> { get }
    var maxNameLength: Observable<Int> { get }
    var currentNumber: Observable<Int> { get }
    var names: Observable<[String]> { get }
    var isValidate: Observable<Bool> { get }
    var updateNames: AnyObserver<[String]> { get }
    
    func increaseNumber()
    func decreaseNumber()
}

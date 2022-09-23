//
//  TypingUseCaseProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/22.
//

import Foundation
import RxSwift

protocol TypingUseCaseProtocol: AnyObject {
    
    var composition: Composition { get }
    
    var returnPressed: AnyObserver<Void> { get }
    var currentUserText: AnyObserver<String> { get }
    
    var elapesdTime: Observable<Int> { get }
    var accuracy: Observable<Int> { get }
    var typingSpeed: Observable<Int> { get }
    var acceleration: Observable<Int> { get }
    var progression: Observable<Double> { get }
    var currentOriginalText: Observable<String> { get }
    var nextOriginalText: Observable<String> { get }
    var userTextToBeUpdated: Observable<String> { get }
    var abused: Observable<Void> { get }
    var finished: Observable<Void> { get }
    
    func start()
    func reset()
    func updateTypingAttributes(_ attributes: TypingAttributes)
    func getRecord() -> Observable<Record>
    func getTypingTexts() -> Observable<[TypingText]>
}

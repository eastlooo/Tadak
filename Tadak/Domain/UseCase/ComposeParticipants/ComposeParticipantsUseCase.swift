//
//  ComposeParticipantsUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/18.
//

import Foundation
import RxSwift
import RxRelay

final class ComposeParticipantsUseCase: ComposeParticipantsUseCaseProtocol {
    
    var minNumber: Observable<Int> { _minNumber.asObservable() }
    var maxNumber: Observable<Int> { _maxNumber.asObservable() }
    var maxNameLength: Observable<Int> { _maxNameLength.asObservable() }
    var currentNumber: Observable<Int> { _currentNumber.asObservable() }
    var names: Observable<[String]> { _names.asObservable() }
    var isValidate: Observable<Bool> { _isValidate.asObservable() }
    var updateNames: AnyObserver<[String]> { _names.asObserver() }
    
    private let disposeBag = DisposeBag()
    private let _minNumber = BehaviorRelay<Int>(value: 2)
    private let _maxNumber = BehaviorRelay<Int>(value: 8)
    private let _maxNameLength = BehaviorRelay<Int>(value: 6)
    private let _currentNumber = BehaviorRelay<Int>(value: 2)
    private let _names = BehaviorSubject<[String]>(value: ["", ""])
    private let _isValidate = BehaviorRelay<Bool>(value: false)
    
    private let _increaseNumber = PublishRelay<Void>()
    private let _decreaseNumber = PublishRelay<Void>()
    
    init() {
        bind()
    }
}

extension ComposeParticipantsUseCase {
    
    func increaseNumber() {
        _increaseNumber.accept(Void())
    }
    
    func decreaseNumber() {
        _decreaseNumber.accept(Void())
    }
}

private extension ComposeParticipantsUseCase {
    
    func bind() {
        // Increase number
        _increaseNumber.asObservable()
            .withLatestFrom(_currentNumber)
            .withLatestFrom(_maxNumber) { ($0, $1) }
            .filter { $0 < $1 }
            .map { $0.0 + 1 }
            .bind(to: _currentNumber)
            .disposed(by: disposeBag)
        
        // Decrease number
        _decreaseNumber.asObservable()
            .withLatestFrom(_currentNumber)
            .withLatestFrom(_minNumber) { ($0, $1) }
            .filter { $0 > $1 }
            .map { $0.0 - 1 }
            .bind(to: _currentNumber)
            .disposed(by: disposeBag)
        
        // Update number of names
        _currentNumber
            .withLatestFrom(_names) { ($0, $1) }
            .map { currentNum, names -> [String] in
                if currentNum > names.count {
                    let count = currentNum - names.count
                    return names + Array<String>(repeating: "", count: count)
                } else if currentNum < names.count {
                    return names[..<currentNum].map { $0 }
                } else {
                    return names
                }
            }
            .bind(to: _names)
            .disposed(by: disposeBag)
        
        // Check validate
        _names
            .filter { $0.count > 0 }
            .map { $0.filter(\.isEmpty).isEmpty }
            .bind(to: _isValidate)
            .disposed(by: disposeBag)
    }
}

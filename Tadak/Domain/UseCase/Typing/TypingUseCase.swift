//
//  TypingUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/14.
//

import Foundation
import RxSwift
import RxCocoa

final class TypingUseCase {
    
    let composition: Composition
    
    var returnPressed: AnyObserver<Void> { _returnPressed.asObserver() }
    var currentUserText: AnyObserver<String> { _currentUserText.asObserver() }
    
    var elapesdTime: Observable<Int> { _elapesdTime.asObservable() }
    var accuracy: Observable<Int> { _accuracy.asObservable() }
    var typingSpeed: Observable<Int> { _typingSpeed.asObservable() }
    var acceleration: Observable<Int> { _acceleration.asObservable() }
    var progression: Observable<Double> { _progression.asObservable() }
    var currentOriginalText: Observable<String> { _currentOriginalText.asObservable() }
    var nextOriginalText: Observable<String> { _nextOriginalText.asObservable() }
    var userTextToBeUpdated: Observable<String> { _userTextToBeUpdated.asObservable() }
    var abused: Observable<Void> { _abused.asObservable() }
    var finished: Observable<Void> { _finished.asObservable() }
    
    private var disposeBag = DisposeBag()
    private var isRunningTyping: BehaviorRelay<Bool> = .init(value: false)
    
    private let _elapesdTime  : BehaviorRelay<Int> = .init(value: 0)
    private let _accuracy: BehaviorRelay<Int> = .init(value: 0)
    private let _typingSpeed: BehaviorRelay<Int> = .init(value: 0)
    private let _acceleration: BehaviorRelay<Int> = .init(value: 0)
    private let _progression: BehaviorRelay<Double> = .init(value: 0)
    private let _abused = PublishRelay<Void>()
    private let _returnPressed = PublishSubject<Void>()
    private let _finished = PublishRelay<Void>()
    
    // OriginalText
    private let _originalTextList: BehaviorRelay<[String]> = .init(value: [])
    private let _currentOriginalText: BehaviorRelay<String> = .init(value: "")
    private let _nextOriginalText: BehaviorRelay<String> = .init(value: "")
    
    // UserText
    private let _userTextList: BehaviorRelay<[String]> = .init(value: [])
    private let _currentUserText: BehaviorSubject<String> = .init(value: "")
    private let _userTextToBeUpdated = PublishRelay<String>()
    private let _textIndex: BehaviorRelay<Int> = .init(value: 0)
    
    init(composition: Composition) {
        self.composition = composition
        
        bind()
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension TypingUseCase: TypingUseCaseProtocol {
    
    func start() {
        guard !isRunningTyping.value else { return }
        
        isRunningTyping.accept(true)
    }
    
    func reset() {
        let originalTextList = _originalTextList.value
        
        DispatchQueue.main.async {
            self.disposeBag = DisposeBag()
            
            self._elapesdTime.accept(0)
            self._accuracy.accept(0)
            self._typingSpeed.accept(0)
            self._userTextList.accept([])
            self._currentOriginalText.accept("")
            self._nextOriginalText.accept("")
            self._acceleration.accept(0)
            self._progression.accept(0)
            self._currentUserText.onNext("")
            self._textIndex.accept(0)
            self._userTextToBeUpdated.accept("")
        
            self.bind()
            self._originalTextList.accept(originalTextList)
        }
    }
    
    func updateTypingAttributes(_ attributes: TypingAttributes) {
        let contents = composition.contents
        let typingList = attributes.seperateContents(contents)
        _originalTextList.accept(typingList)
    }
    
    func getRecord() -> Observable<Record> {
        return Observable
            .combineLatest(_elapesdTime, _typingSpeed, _accuracy)
            .map(Record.init)
    }
}

private extension TypingUseCase {
    
    func bind() {
        // Set ElapsedTime
        Driver<Int>.interval(.seconds(1))
            .asObservable()
            .withLatestFrom(isRunningTyping)
            .filter { $0 }
            .withLatestFrom(_elapesdTime) { $1 + 1 }
            .bind(to: _elapesdTime)
            .disposed(by: disposeBag)
        
        let doneUserText = PublishRelay<String>()
        
        doneUserText.asObservable()
            .withLatestFrom(_userTextList) { $1 + [$0] }
            .bind(to: _userTextList)
            .disposed(by: disposeBag)
        
        let currentOriginalText = Observable
            .combineLatest(_originalTextList, _textIndex)
            .map { (list: [String], index: Int) -> String in
                (index < list.count) ? list[index] : ""
            }
            .share()
        
        currentOriginalText
            .bind(to: _currentOriginalText)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(_originalTextList, _textIndex)
            .map { (list: [String], index: Int) -> String in
                (index+1 < list.count) ? list[index+1] : ""
            }
            .bind(to: _nextOriginalText)
            .disposed(by: disposeBag)
        
        // Check Abusing
        _currentUserText
            .scan(("", false)) { prev, new -> (text: String, abused: Bool) in
                if new.count - prev.text.count >= 2 {
                    return (new, true)
                }
                return (new, false)
            }
            .filter(\.1)
            .map { _ in }
            .bind(to: _abused)
            .disposed(by: disposeBag)
        
        // Compare Input Text with Orginal Text upto minimum index
        let comparitive = _currentUserText
            .withLatestFrom(currentOriginalText) { (userText: $0, correctText: $1) }
            .map { (userText, correctText) -> (userText: String, correctText: String) in
                if userText.count <= correctText.count {
                    let index = correctText.index(correctText.startIndex, offsetBy: userText.count)
                    return (userText, String(correctText[..<index]))
                } else {
                    let index = userText.index(userText.startIndex, offsetBy: correctText.count)
                    return (String(userText[..<index]), correctText)
                }
            }
            .share()
        
        // Caculate TypingSpeed
        let storedLettersCount = BehaviorRelay<Int>(value: 0)
        
        let lettersCount = comparitive
            .map { (userText, correctText) -> Int in
                guard userText.count > 0 else { return 0 }
                
                var userText = userText
                var correctText = correctText
                var lettersCount = 0
                
                for _ in 0..<userText.count {
                    let lastChar = userText.removeLast()
                    if lastChar == correctText.removeLast() {
                        lettersCount += Hangul.decompose(lastChar).count
                    }
                }
                
                return lettersCount
            }
            .withLatestFrom(storedLettersCount) { $0 + $1 }
            .share()
        
        Observable
            .combineLatest(elapesdTime, lettersCount)
            .map { time, count -> Int in
                guard time > 0 else { return 0 }
                return count * 60 / time
            }
            .bind(to: _typingSpeed)
            .disposed(by: disposeBag)
        
        // Calculate Acceleration
        let storedCountEverySecond = BehaviorRelay<Int>(value: 0)
        let divider = 3
        let accelerationBuffer = BehaviorRelay<[Int]>(value: Array<Int>(repeating: 0, count: divider * 2))
        
        let acceleration = Driver<Int>.interval(.milliseconds(1000/divider)).asObservable()
            .withLatestFrom(storedCountEverySecond)
            .withLatestFrom(lettersCount) { ($1 - $0) * 60 * divider }
            .withLatestFrom(_typingSpeed) { (speed: $0, diff: $0-$1) }
            .map(\.diff)
            .share()
        
        acceleration
            .withLatestFrom(lettersCount)
            .bind(to: storedCountEverySecond)
            .disposed(by: disposeBag)
        
        let newAccelerations = acceleration
            .withLatestFrom(accelerationBuffer) { Array($1[1...]) + [$0] }
            .share()
        
        newAccelerations
            .bind(to: accelerationBuffer)
            .disposed(by: disposeBag)
        
        _elapesdTime
            .withLatestFrom(newAccelerations)
            .map { $0.reduce(0, +) / $0.count }
            .bind(to: _acceleration)
            .disposed(by: disposeBag)
        
        // Caculate Accuracy
        let storedCorrect = BehaviorRelay<(correctCount: Int, totalCount: Int)>(value: (0, 0))
        
        let correct = comparitive
            .map { (userText, correctText) -> (correctCount: Int, totalCount: Int, last: Bool) in
                guard userText.count > 1 else { return (0, 0, true) }
                
                var userText = userText
                var correctText = correctText
                var totalCount = userText.count - 1
                var correctCount = 0
                var last = false
                
                if userText.removeLast() == correctText.removeLast() {
                    correctCount += 1
                    totalCount += 1
                    last = true
                }
                
                for _ in 0..<userText.count {
                    if userText.removeLast() == correctText.removeLast() {
                        correctCount += 1
                    }
                }
                
                return (correctCount, totalCount, last)
            }
            .withLatestFrom(storedCorrect) { current, stored -> (correctCount: Int, totalCount: Int, last: Bool) in
                let correctCount = current.correctCount + stored.correctCount
                let totalCount = current.totalCount + stored.totalCount
                return (correctCount, totalCount, current.last)
            }
            .share()
        
        correct
            .map { correctCount, totalCount, _ -> Int in
                guard totalCount > 0 else { return 0 }
                return correctCount * 100 / totalCount
            }
            .bind(to: _accuracy)
            .disposed(by: disposeBag)
        
        // Calculate Progression
        let totalNumOfChar = _originalTextList
            .map { $0.joined().count }
            .filter { $0 > 0 }
        
        comparitive
            .map(\.userText.count)
            .withLatestFrom(storedCorrect.map(\.totalCount)) { $0 + $1 }
            .withLatestFrom(totalNumOfChar) { input, total -> Double in
                let share = Double(input) / Double(total)
                // 소수점 셋 째 자리에서 올림
                return ceil(share * 100) / 100
            }
            .bind(to: _progression)
            .disposed(by: disposeBag)
        
        // New Text Line
        let newUserText = Observable.merge(
            _currentUserText
                .withLatestFrom(_currentOriginalText) { input, original -> (text: String, new: String)? in
                    guard input.count > original.count, original.count > 0 else { return nil }
                    let index = input.index(input.startIndex, offsetBy: original.count)
                    let text = String(input[..<index])
                    let output = String(input[index...])
                    return (text, output)
                },
            _returnPressed
                .withLatestFrom(_currentUserText)
                .withLatestFrom(_currentOriginalText) { input, original -> (text: String, new: String)? in
                    guard input.count == original.count else { return nil }
                    return (input, "")
                }
        ).share()
        
        let newTextIndex = newUserText
            .compactMap { $0 }
            .withLatestFrom(_textIndex) { $1 + 1 }
            .share()
        
        newTextIndex
            .bind(to: _textIndex)
            .disposed(by: disposeBag)
        
        newTextIndex
            .withLatestFrom(correct)
            .map { ($0.correctCount, $0.totalCount + ($0.last ? 0 : 1)) }
            .bind(to: storedCorrect)
            .disposed(by: disposeBag)
        
        newTextIndex
            .withLatestFrom(lettersCount)
            .bind(to: storedLettersCount)
            .disposed(by: disposeBag)
        
        let updatedUserText = newUserText
            .compactMap { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .do { doneUserText.accept($0.text) }
            .map(\.new)
            .share()
        
        updatedUserText
            .bind(onNext: { [weak self] text in
                self?._currentUserText.onNext(text)
                self?._userTextToBeUpdated.accept(text)
            })
            .disposed(by: disposeBag)
        
        // Tying End
        _textIndex
            .withLatestFrom(_originalTextList) { ($0, $1) }
            .filter { $1.count > 0 }
            .filter { $0 >= $1.count }
            .map { _ in }
            .bind(to: _finished)
            .disposed(by: disposeBag)
        
        _finished
            .map { _ in false }
            .bind(to: isRunningTyping)
            .disposed(by: disposeBag)
    }
}

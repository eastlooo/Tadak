//
//  CountdownView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/07.
//

import UIKit
import SnapKit
import Lottie
import RxSwift
import RxCocoa

final class CountdownView: UIView {
    
    // MARK: Properties
    private var disposeBag = DisposeBag()
    
    fileprivate let isFinished: BehaviorRelay<Bool> = .init(value: false)
    
    private let startCountdown: BehaviorRelay<Bool> = .init(value: false)
    private let timerValue: BehaviorRelay<Int> = .init(value: 3)
    
    private let animationView: AnimationView = {
        let animationView = AnimationView(name: "countdown")
        animationView.isHidden = true
        return animationView
    }()
    
    fileprivate lazy var startButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "start_large"), for: .normal)
        button.addTarget(self, action: #selector(startButtonHandler), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
    
    // MARK: Actions
    @objc
    private func startButtonHandler() {
        startButton.isHidden = true
        animationView.isHidden = false
        animationView.play()
        startCountdown.accept(true)
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .customNavy
    }
    
    private func layout() {
        self.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.top.bottom.centerX.equalToSuperview()
        }
        
        self.addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(80)
        }
    }
    
    private func bind() {
        let loop = Driver<Int>.interval(.seconds(1)).map { _ in 1 }
        
        startCountdown
            .filter { $0 }
            .take(1)
            .flatMap { _ in loop }
            .withLatestFrom(timerValue) { $1 - $0 }
            .bind(to: timerValue)
            .disposed(by: disposeBag)
        
        timerValue
            .map { $0 == 0 }
            .filter { $0 }
            .bind(to: isFinished)
            .disposed(by: disposeBag)
        
        timerValue
            .bind(onNext: { print("DEBUG: timer \($0)") })
            .disposed(by: disposeBag)
    }
    
    fileprivate func hide() {
        animationView.stop()
        animationView.isHidden = true
        self.isHidden = true
        self.disposeBag = DisposeBag()
    }
    
    fileprivate func reset() {
        startButton.isHidden = false
        timerValue.accept(3)
        startCountdown.accept(false)
        isFinished.accept(false)
        bind()
        
        self.isHidden = false
    }
}

// MARK: - Rx+Extension
extension Reactive where Base: CountdownView {
    
    // MARK: Binder
    var hide: Binder<Void> {
        return Binder(base) { base, _ in
            base.hide()
        }
    }
    
    var reset: Binder<Void> {
        return Binder(base) { base, _ in
            base.reset()
        }
    }
    
    // MARK: ControlEvent
    var start: ControlEvent<Void> {
        return base.startButton.rx.tap
    }
    
    var isFinished: ControlEvent<Bool> {
        return ControlEvent(events: base.isFinished)
    }
}

//
//  PracticeTypingViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/07.
//

import UIKit
import SnapKit
import ReactorKit

final class PracticeTypingViewController: UIViewController {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private let typingFont: UIFont = .notoSansKR(ofSize: 18, weight: .bold)!
    
    var typingAttributes: TypingAttributes {
        let screenWidth = UIScreen.main.bounds.width
        return TypingAttributes(
            width: typingSheet.getTextWidth(parentWidth: screenWidth),
            attributes: [.font: typingFont]
        )
    }
    
    private let navigationView = HomeButtonTypeNavigationView()
    private let progressBar = ProgressBar()
    private let dashboard = TypingDashboard()
    private lazy var typingSheet = TypingSheet(typingFont: typingFont)
    private var countdownView: CountdownView? = CountdownView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        progressBar.progression = 0.2
        _ = typingSheet.becomeFirstResponder()
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .customNavy
        
        navigationView.title = "연습 모드"
        typingSheet.typingFont = typingFont
    }
    
    private func layout() {
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(5)
        }
        
        view.addSubview(dashboard)
        dashboard.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom)
            $0.left.right.equalToSuperview()
        }
        
        view.addSubview(countdownView!)
        countdownView!.snp.makeConstraints {
            $0.edges.equalTo(dashboard)
        }
        
        view.addSubview(typingSheet)
        typingSheet.snp.makeConstraints {
            $0.top.equalTo(dashboard.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension PracticeTypingViewController: View {
    
    func bind(reactor: PracticeTypingViewReactor) {
        
        // MARK: Action
        Observable.just(typingAttributes)
            .map(PracticeTypingViewReactor.Action.typingAttributesHasSet)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationView.rx.homeButtonTapped
            .map(PracticeTypingViewReactor.Action.homeButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        countdownView!.rx.isFinished
            .filter { $0 }
            .map { _ in }
            .map(PracticeTypingViewReactor.Action.typingHasStarted)
            .bind(to: reactor.action)
            .disposed(by: countdownView!.disposeBag)
        
        typingSheet.rx.typing.orEmpty
            .map(PracticeTypingViewReactor.Action.currentUserText)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        typingSheet.rx.returnPressed
            .map(PracticeTypingViewReactor.Action.returnPressed)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.state.map(\.title)
            .take(1)
            .bind(to: typingSheet.rx.title)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.currentOriginalText)
            .distinctUntilChanged()
            .bind(to: typingSheet.rx.currentTyping)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.nextOriginalText)
            .distinctUntilChanged()
            .bind(to: typingSheet.rx.nextTyping)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap(\.userText)
            .distinctUntilChanged()
            .map(\.data)
            .bind(to: typingSheet.rx.typing)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.elapsedTime)
            .bind(to: dashboard.rx.elapsedTime)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.accuracy)
            .distinctUntilChanged()
            .bind(to: dashboard.rx.accuracy)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.typingSpeed)
            .distinctUntilChanged()
            .bind(to: dashboard.rx.typingSpeed)
            .disposed(by: disposeBag)
        
        // MARK: View
        countdownView!.rx.isFinished
            .filter { $0 }
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] _ in
                self?.countdownView?.removeFromSuperview()
                self?.countdownView = nil
            })
            .disposed(by: countdownView!.disposeBag)
        
        countdownView!.rx.isFinished
            .filter { $0 }
            .bind(to: typingSheet.rx.isTypingEnabled)
            .disposed(by: disposeBag)
    }
}

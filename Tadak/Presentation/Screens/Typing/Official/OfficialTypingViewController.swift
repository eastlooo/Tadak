//
//  OfficialTypingViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/24.
//

import UIKit
import SnapKit
import ReactorKit

final class OfficialTypingViewController: UIViewController {
    
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
    private let countdownView = CountdownView()
    private lazy var typingSheet = TypingSheet(typingFont: typingFont)
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _ = typingSheet.becomeFirstResponder()
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .customNavy
        
        navigationView.title = "실전 모드"
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
            $0.height.equalTo(85)
        }
        
        view.addSubview(countdownView)
        countdownView.snp.makeConstraints {
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
extension OfficialTypingViewController: View {
    
    func bind(reactor: OfficialTypingViewReactor) {
        
        // MARK: Action
        Observable.just(typingAttributes)
            .map(OfficialTypingViewReactor.Action.typingAttributesHasSet)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationView.rx.homeButtonTapped
            .map(OfficialTypingViewReactor.Action.homeButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        countdownView.rx.isFinished
            .filter { $0 }
            .map { _ in }
            .map(OfficialTypingViewReactor.Action.typingHasStarted)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        typingSheet.rx.typing.orEmpty
            .map(OfficialTypingViewReactor.Action.currentUserText)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        typingSheet.rx.returnPressed
            .map(OfficialTypingViewReactor.Action.returnPressed)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.pulse(\.$title)
            .bind(to: typingSheet.rx.title)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$currentOriginalText)
            .bind(to: typingSheet.rx.currentTyping)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$nextOriginalText)
            .bind(to: typingSheet.rx.nextTyping)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$userText)
            .bind(to: typingSheet.rx.typing)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$elapsedTime)
            .bind(to: dashboard.rx.elapsedTime)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$accuracy)
            .distinctUntilChanged()
            .bind(to: dashboard.rx.accuracy)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$typingSpeed)
            .bind(to: dashboard.rx.typingSpeed)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$progression)
            .distinctUntilChanged()
            .map { CGFloat($0) }
            .bind(to: progressBar.rx.progression)
            .disposed(by: disposeBag)
        
        // MARK: View
        countdownView.rx.isFinished
            .filter { $0 }
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .map { _ in }
            .bind(to: countdownView.rx.hide)
            .disposed(by: disposeBag)
        
        countdownView.rx.isFinished
            .filter { $0 }
            .bind(to: typingSheet.rx.isTypingEnabled)
            .disposed(by: disposeBag)
    }
}

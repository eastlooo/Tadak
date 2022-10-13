//
//  BettingTypingViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/21.
//

import UIKit
import SnapKit
import ReactorKit
import RxRelay
import GoogleMobileAds

final class BettingTypingViewController: UIViewController {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private var interstitial: GADInterstitialAd?
    
    private let _adDisappeared = PublishRelay<Void>()
    
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
    private let dashboard = SpeedDashboard()
    private let countdownView = CountdownView()
    private let helperView = CharacterHelperView()
    private lazy var typingSheet = TypingSheet(typingFont: typingFont, typingMode: .betting)
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
        loadInterstitialAd()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.helperView.showDescription()
        }
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .customNavy
        
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
            $0.top.equalTo(navigationView.snp.bottom).offset(2)
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
        
        view.addSubview(helperView)
        helperView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.height.equalTo(200)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func loadInterstitialAd() {
        let adUnitID = "ca-app-pub-7391830718641055/4544220099"
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: adUnitID,
                               request: request) { [self] ad, error in
            if let error = error {
                print("ERROR: \(error)")
                _adDisappeared.accept(Void())
                return
            }
            
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
    }
    
    private func showAd() {
        self.interstitial?.present(fromRootViewController: self)
    }
}

// MARK: - Bind
extension BettingTypingViewController: View {
    
    func bind(reactor: BettingTypingViewReactor) {
        
        // MARK: Action
        Observable.just(typingAttributes)
            .map(BettingTypingViewReactor.Action.typingAttributesHasSet)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationView.rx.homeButtonTapped
            .map(BettingTypingViewReactor.Action.homeButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        countdownView.rx.isFinished
            .filter { $0 }
            .map { _ in }
            .map(BettingTypingViewReactor.Action.typingHasStarted)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        typingSheet.rx.typing.orEmpty
            .map(BettingTypingViewReactor.Action.currentUserText)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        typingSheet.rx.returnPressed
            .map(BettingTypingViewReactor.Action.returnPressed)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        _adDisappeared
            .map(BettingTypingViewReactor.Action.adDisappeared)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.pulse(\.$characterID)
            .bind(onNext: helperView.setCharacterID)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$title)
            .bind(to: typingSheet.rx.title)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$participant)
            .bind(to: navigationView.rx.title)
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
        
        reactor.pulse(\.$acceleration)
            .bind(to: dashboard.rx.acceleration)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$progression)
            .distinctUntilChanged()
            .map { CGFloat($0) }
            .bind(to: progressBar.rx.progression)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldReset)
            .filter { $0 }
            .map { !$0 }
            .bind(to: typingSheet.rx.isTypingEnabled)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldReset)
            .filter { $0 }
            .map { _ in }
            .bind(to: countdownView.rx.reset)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldReset)
            .filter { $0 }
            .bind(onNext: { [weak self] _ in
                _ = self?.typingSheet.resignFirstResponder()
                self?.helperView.showDescription()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$adAppear)
            .filter { $0 }
            .take(1)
            .map { _ in }
            .bind(onNext: showAd)
            .disposed(by: disposeBag)
        
        // MARK: View
        countdownView.rx.start
            .bind(onNext: { [weak self] _ in
                _ = self?.typingSheet.becomeFirstResponder()
                self?.helperView.hideDescription()
            })
            .disposed(by: disposeBag)
        
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

// MARK: - GADFullScreenContentDelegate
extension BettingTypingViewController: GADFullScreenContentDelegate {
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("ERROR: \(error)")
        _adDisappeared.accept(Void())
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        _adDisappeared.accept(Void())
    }
}

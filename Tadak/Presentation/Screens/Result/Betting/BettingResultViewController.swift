//
//  BettingResultViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/22.
//

import UIKit
import SnapKit
import ReactorKit
import RxRelay

final class BettingResultViewController: UIViewController {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private let _animated = PublishRelay<Void>()
    
    private let navigationView = HomeButtonTypeNavigationView()
    private let podiumView = BettingPodiumView()
    private let tableView = BettingResultTableView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        podiumView.animateShow { [weak self] in
            self?._animated.accept(Void())
        }
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .customNavy
        
        navigationView.title = "내기 결과"
    }
    
    private func layout() {
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        
        view.addSubview(podiumView)
        podiumView.snp.makeConstraints {
            let height = UIScreen.main.bounds.width * 0.6
            $0.top.equalTo(navigationView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(height)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(podiumView.snp.bottom).offset(-4)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension BettingResultViewController: View {
    
    func bind(reactor: BettingResultViewReactor) {
        
        // MARK: Action
        navigationView.rx.homeButtonTapped
            .map(BettingResultViewReactor.Action.homeButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        Observable
            .combineLatest(_animated, reactor.pulse(\.$items))
            .map(\.1)
            .bind(to: tableView.rx.items)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$topTwo)
            .compactMap { $0 }
            .bind(onNext: podiumView.setPodium)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$topThree)
            .compactMap { $0 }
            .bind(onNext: podiumView.setPodium)
            .disposed(by: disposeBag)
    }
}

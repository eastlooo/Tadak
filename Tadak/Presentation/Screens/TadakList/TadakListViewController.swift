//
//  TadakListViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit
import ReactorKit

final class TadakListViewController: UIViewController {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private let navigationView = HomeButtonTypeNavigationView()
    private let tableView = TadakListTableView()
    
    private let practiceModeButton: BorderedButton = {
        let button = BorderedButton()
        button.title = TypingMode.practice.description
        button.titleFont = .notoSansKR(ofSize: 14, weight: .bold)
        return button
    }()
    
    private let officialModeButton: BorderedButton = {
        let button = BorderedButton()
        button.title = TypingMode.official.description
        button.titleFont = .notoSansKR(ofSize: 14, weight: .bold)
        return button
    }()
    
    private let bettingModeButton: BorderedButton = {
        let button = BorderedButton()
        button.title = TypingMode.betting.description
        button.titleFont = .notoSansKR(ofSize: 14, weight: .bold)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .customNavy
        
        navigationView.title = "타닥타닥 글"
    }
    
    private func layout() {
        let buttonStackView = UIStackView(arrangedSubviews: [
            practiceModeButton, officialModeButton, bettingModeButton
        ])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 10
        buttonStackView.distribution = .fillEqually
        
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(5)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(45)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(15)
            $0.left.right.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension TadakListViewController: View {
    
    func bind(reactor: TadakListViewReactor) {
        
        // MARK: Action
        navigationView.rx.homeButtonTapped
            .map(TadakListViewReactor.Action.homeButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        practiceModeButton.rx.tap
            .map { _ in TypingMode.practice }
            .map(TadakListViewReactor.Action.typingModeButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        officialModeButton.rx.tap
            .map { _ in TypingMode.official }
            .map(TadakListViewReactor.Action.typingModeButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bettingModeButton.rx.tap
            .map { _ in TypingMode.betting }
            .map(TadakListViewReactor.Action.typingModeButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map(TadakListViewReactor.Action.itemSelected)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.pulse(\.$typingMode)
            .map { $0 != .practice }
            .bind(to: practiceModeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$typingMode)
            .map { $0 != .official }
            .bind(to: officialModeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$typingMode)
            .map { $0 != .betting }
            .bind(to: bettingModeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$items)
            .bind(to: tableView.rx.items)
            .disposed(by: disposeBag)
    }
}

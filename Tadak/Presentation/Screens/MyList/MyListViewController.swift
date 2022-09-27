//
//  MyListViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit
import ReactorKit

final class MyListViewController: UIViewController {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private let navigationView = HomeButtonTypeNavigationView()
    private let tableView = MyListTableView()
    private let headerView = MyListHeaderView()
    
    private let practiceModeButton: BorderedButton = {
        let button = BorderedButton()
        button.title = "연습 모드"
        button.titleFont = .notoSansKR(ofSize: 14, weight: .medium)
        return button
    }()

    private let bettingModeButton: BorderedButton = {
        let button = BorderedButton()
        button.title = "내기 모드"
        button.titleFont = .notoSansKR(ofSize: 14, weight: .medium)
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
        
        navigationView.title = "나만의 글"
        
        tableView.tableHeaderView = headerView
        headerView.frame.size.height = 91.5
        
        practiceModeButton.isEnabled = false
    }
    
    private func layout() {
        let buttonStackView = UIStackView(arrangedSubviews: [
            practiceModeButton, bettingModeButton
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
            $0.top.equalTo(navigationView.snp.bottom).offset(10)
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
extension MyListViewController: View {
    
    func bind(reactor: MyListViewReactor) {
        
        // MARK: Action
        navigationView.rx.homeButtonTapped
            .map(MyListViewReactor.Action.homeButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        practiceModeButton.rx.tap
            .map { _ in TypingMode.practice }
            .map(MyListViewReactor.Action.typingModeButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bettingModeButton.rx.tap
            .map { _ in TypingMode.betting }
            .map(MyListViewReactor.Action.typingModeButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map(MyListViewReactor.Action.itemSelected)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        headerView.rx.addButtonTapped
            .map(MyListViewReactor.Action.addButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.deleteItem
            .map(MyListViewReactor.Action.deleteItem)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.pulse(\.$typingMode)
            .map { $0 != .practice }
            .bind(to: practiceModeButton.rx.isEnabled)
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

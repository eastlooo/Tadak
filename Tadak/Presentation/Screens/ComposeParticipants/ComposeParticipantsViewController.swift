//
//  ComposeParticipantsViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit
import ReactorKit

final class ComposeParticipantsViewController: UIViewController {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private let navigationView = ListButtonTypeNavigationView()
    private let tableView = ComposeParticipantsTableView()
    private let headerView = ComposeParticipantsHeaderView()
    private let footerView = ComposeParticipantsFooterView()
    private lazy var accessoryView = KeyboardDock(root: startButton, parent: self.view)
    
    private let startButton: TextButton = {
        let button = TextButton(colorType: .coral)
        button.title = "시작하기"
        button.titleFont = .notoSansKR(ofSize: 20, weight: .bold)
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
        
        navigationView.title = "참가자 입력"
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        headerView.frame.size.height = 230
        footerView.frame.size.height = 160
        
        startButton.isEnabled = false
    }
    
    private func layout() {
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        // execute lazy var property
        _ = accessoryView
    }
}

// MARK: - Bind
extension ComposeParticipantsViewController: View {
    
    func bind(reactor: ComposeParticipantsViewReactor) {
        
        // MARK: Action
        navigationView.rx.listButtonTapped
            .map(ComposeParticipantsViewReactor.Action.listButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        headerView.rx.minusButtonTapped
            .map(ComposeParticipantsViewReactor.Action.minusButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        headerView.rx.plusButtonTapped
            .map(ComposeParticipantsViewReactor.Action.plusButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.pulse(\.$minimumNumber)
            .bind(to: headerView.rx.minimumNumber)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$maximumNumber)
            .bind(to: headerView.rx.maximumNumber)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$currentNumber)
            .bind(to: headerView.rx.currentNumber)
            .disposed(by: disposeBag)
    }
}

//
//  ComposeParticipantsViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit
import ReactorKit
import RxKeyboard

final class ComposeParticipantsViewController: UIViewController {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private let navigationView = ListButtonTypeNavigationView()
    private let tableView = ComposeParticipantsTableView()
    private let headerView = ComposeParticipantsHeaderView()
    private let footerView = ComposeParticipantsFooterView()
    
    private let startButton: TextButton = {
        let button = TextButton(colorType: .coral)
        button.title = "시작하기"
        button.titleFont = .notoSansKR(ofSize: 20, weight: .bold)
        return button
    }()
    
    private lazy var keyboardDock = KeyboardDock(root: startButton,
                                                 parent: self.view)
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.contentInset.bottom = keyboardDock.frame.height
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .customNavy
        
        navigationView.title = "참가자 입력"
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        headerView.frame.size.width = UIScreen.main.bounds.width
        footerView.frame.size.width = UIScreen.main.bounds.width
        headerView.frame.size.height = 230
        footerView.frame.size.height = 30
        
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
        
        startButton.rx.tap
            .map(ComposeParticipantsViewReactor.Action.startButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.pulse(\.$items)
            .bind(to: tableView.rx.items)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$minimumNumber)
            .compactMap { $0 }
            .bind(to: headerView.rx.minimumNumber)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$maximumNumber)
            .compactMap { $0 }
            .bind(to: headerView.rx.maximumNumber)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$currentNumber)
            .compactMap { $0 }
            .bind(to: headerView.rx.currentNumber)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isValidate)
            .distinctUntilChanged()
            .bind(to: startButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // MARK: View
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(keyboardDock.rx.keyboardHeight)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.isHidden
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let inset = self.keyboardDock.frame.height
                self.tableView.contentInset.bottom = inset
            })
            .disposed(by: disposeBag)
    }
}

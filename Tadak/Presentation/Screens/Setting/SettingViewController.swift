//
//  SettingViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/29.
//

import UIKit
import SnapKit
import ReactorKit
import RxRelay

final class SettingViewController: UIViewController {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private let _reset = PublishRelay<Void>()
    
    private let navigationView = HomeButtonTypeNavigationView()
    private let tableView = SettingTableView()
    
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
        
        navigationView.title = "설정"
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

// MARK: Bind
extension SettingViewController: View {
    
    func bind(reactor: SettingViewReactor) {
        
        // MARK: Action
        navigationView.rx.homeButtonTapped
            .map(SettingViewReactor.Action.homeButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map(SettingViewReactor.Action.itemSelected)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        _reset
            .map(SettingViewReactor.Action.reset)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.pulse(\.$items)
            .bind(to: tableView.rx.items)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$loaderAppear)
            .compactMap { $0 }
            .distinctUntilChanged()
            .bind(to: Loader.rx.show)
            .disposed(by: disposeBag)
    }
}

extension SettingViewController {
    
    func resetAllData() {
        _reset.accept(Void())
    }
}

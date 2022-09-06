//
//  ComposeParticipantsViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit

final class ComposeParticipantsViewController: UIViewController {
    
    // MARK: Properties
    private let navigationView = ListButtonTypeNavigationView()
    private let headerView = ComposeParticipantsHeaderView()
    private let footerView = ComposeParticipantsFooterView()
    
    private let startButton: TextButton = {
        let button = TextButton(colorType: .coral)
        button.titleFont = .notoSansKR(ofSize: 20, weight: .bold)
        return button
    }()
    
    private lazy var accessoryView: TadakInputAccessoryView = {
        let accessoryView = TadakInputAccessoryView(rootView: startButton)
        return accessoryView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .customNavy
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.indicatorStyle = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.register(
            ComposeParticipantsCell.self,
            forCellReuseIdentifier: ComposeParticipantsCell.reuseIdentifier
        )
        tableView.dataSource = self
        return tableView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    override var inputAccessoryView: UIView? { accessoryView }
    override var canBecomeFirstResponder: Bool { true }
    
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
        startButton.title = "시작하기"
        
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
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(tableView.snp.bottom).offset(-30)
            $0.height.equalTo(55)
        }
    }
}

extension ComposeParticipantsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ComposeParticipantsCell.reuseIdentifier,
            for: indexPath
        ) as! ComposeParticipantsCell
        return cell
    }
}

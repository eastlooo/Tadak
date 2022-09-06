//
//  MyListViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit

final class MyListViewController: UIViewController {
    
    // MARK: Properties
    private let navigationView = HomeButtonTypeNavigationView()
    
    private let practiceModeButton: BorderedButton = {
        let button = BorderedButton()
        button.titleFont = .notoSansKR(ofSize: 14, weight: .medium)
        return button
    }()

    private let bettingModeButton: BorderedButton = {
        let button = BorderedButton()
        button.titleFont = .notoSansKR(ofSize: 14, weight: .medium)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .customNavy
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 100
        tableView.register(
            MyListCell.self,
            forCellReuseIdentifier: MyListCell.reuseIdentifier
        )
        tableView.dataSource = self
        return tableView
    }()
    
    private let headerView = MyListHeaderView()
    
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
        practiceModeButton.title = "연습 모드"
        bettingModeButton.title = "내기 모드"
        
        tableView.tableHeaderView = headerView
        headerView.frame.size.height = 100
        
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

extension MyListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MyListCell.reuseIdentifier,
            for: indexPath
        ) as! MyListCell
        return cell
    }
}

//
//  TadakListViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit

final class TadakListViewController: UIViewController {
    
    // MARK: Properties
    private let navigationView = TadakNavigationView()
    
    private let practiceModeButton: BorderedButton = {
        let button = BorderedButton()
        button.titleFont = .notoSansKR(ofSize: 14, weight: .medium)
        return button
    }()
    
    private let officialModeButton: BorderedButton = {
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
            TadakListCell.self,
            forCellReuseIdentifier: TadakListCell.reuseIdentifier
        )
        tableView.dataSource = self
        return tableView
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
        practiceModeButton.title = "연습 모드"
        officialModeButton.title = "실전 모드"
        bettingModeButton.title = "내기 모드"
        
        practiceModeButton.isEnabled = false
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

extension TadakListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TadakListCell.reuseIdentifier,
            for: indexPath
        ) as! TadakListCell
        return cell
    }
}

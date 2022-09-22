//
//  BettingResultViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/22.
//

import UIKit
import SnapKit

final class BettingResultViewController: UIViewController {
    
    // MARK: Properties
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
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .customNavy
        
        navigationView.title = "내기 결과"
        podiumView.setPodium(first: "김종국", second: "유재석")
//        podiumView.setPodium(first: "김종국", second: "유재석", third: "하하")
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
            $0.top.equalTo(podiumView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

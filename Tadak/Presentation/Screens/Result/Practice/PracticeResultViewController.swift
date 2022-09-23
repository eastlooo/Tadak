//
//  PracticeResultViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/23.
//

import UIKit
import SnapKit

final class PracticeResultViewController: UIViewController {
    
    // MARK: Properties
    private let navigationView = HomeButtonTypeNavigationView()
    private let dashboard = RecordDashboard()
    private let bottomSheet = UIView()
    private let tableView = PracticeResultTableView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customDarkNavy
        label.font = .notoSansKR(ofSize: 22, weight: .black)
        return label
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
        bottomSheet.backgroundColor = .white
        
        navigationView.title = "연습 결과"
        dashboard.record = Record(elapsedTime: 40, typingSpeed: 496, accuracy: 97)
        titleLabel.text = "메밀꽃 필 무렵"
    }
    
    private func layout() {
        bottomSheet.layer.cornerRadius = 45
        bottomSheet.layer.cornerCurve = .continuous
        bottomSheet.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        
        view.addSubview(dashboard)
        dashboard.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(130)
        }
        
        view.addSubview(bottomSheet)
        bottomSheet.snp.makeConstraints {
            $0.top.equalTo(dashboard.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        bottomSheet.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.centerX.equalToSuperview()
        }
        
        bottomSheet.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

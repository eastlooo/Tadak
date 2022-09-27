//
//  HomeButtonTypeNavigationView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeButtonTypeNavigationView: UIView {
    
    // MARK: Properties
    var title: String? {
        didSet { titleLabel.text = title }
    }
    
    fileprivate var homeButtonTapped: ControlEvent<Void> {
        return homeButton.rx.tap
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansKR(ofSize: 22.0, weight: .black)
        label.textColor = .white
        return label
    }()
    
    private let homeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "exit"), for: .normal)
        return button
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .clear
    }
    
    private func layout() {
        self.snp.makeConstraints {
            $0.height.equalTo(65)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        self.addSubview(homeButton)
        homeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(14)
            $0.width.height.equalTo(44)
        }
    }
}

// MARK: ControlEvent
extension Reactive where Base: HomeButtonTypeNavigationView {
    var homeButtonTapped: ControlEvent<Void> {
        return base.homeButtonTapped
    }
}

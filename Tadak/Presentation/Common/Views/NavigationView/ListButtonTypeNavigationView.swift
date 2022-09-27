//
//  ListButtonTypeNavigationView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ListButtonTypeNavigationView: UIView {
    
    // MARK: Properties
    var title: String? {
        didSet {
            titleLabel.isHidden = (title == nil)
            titleLabel.text = title
        }
    }
    
    var subtitle: String? {
        didSet {
            subtitleLabel.isHidden = (subtitle == nil)
            subtitleLabel.text = subtitle
        }
    }
    
    fileprivate var listButtonTapped: ControlEvent<Void> {
        return listButton.rx.tap
    }
    
    private let titleAlignment: TitleAlignment
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansKR(ofSize: 24.0, weight: .bold)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansKR(ofSize: 18.0, weight: .medium)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    private let listButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "list"), for: .normal)
        return button
    }()
    
    // MARK: Lifecycle
    init(titleAlignment: TitleAlignment = .left) {
        self.titleAlignment = titleAlignment
        super.init(frame: .zero)
        
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
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        titleStackView.axis = .vertical
        titleStackView.spacing = 1
        titleStackView.distribution = .fillProportionally
        titleStackView.alignment = .leading
        
        self.snp.makeConstraints {
            $0.height.equalTo(80)
        }
        
        self.addSubview(listButton)
        listButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(26)
            $0.width.height.equalTo(44)
        }
        
        self.addSubview(titleStackView)
        titleStackView.snp.makeConstraints {
            $0.centerY.equalTo(listButton)
            
            switch titleAlignment {
            case .left: $0.left.equalToSuperview().inset(28)
            case .center: $0.centerX.equalToSuperview()
            }
        }
    }
}

extension ListButtonTypeNavigationView {
    
    enum TitleAlignment {
        case center, left
    }
}

// MARK: - Rx+Extension
extension Reactive where Base: ListButtonTypeNavigationView {
    
    // MARK: ControlEvent
    var listButtonTapped: ControlEvent<Void> {
        return base.listButtonTapped
    }
}

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
        didSet { titleLabel.text = title }
    }
    
    fileprivate var listButtonTapped: ControlEvent<Void> {
        return listButton.rx.tap
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansKR(ofSize: 26.0, weight: .black)
        label.textColor = .white
        return label
    }()
    
    private let listButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "list"), for: .normal)
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
            $0.height.equalTo(72)
        }
        
        self.addSubview(listButton)
        listButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(26)
            $0.width.height.equalTo(44)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(28)
            $0.centerY.equalTo(listButton)
        }
    }
}

// MARK: ControlEvent
extension Reactive where Base: ListButtonTypeNavigationView {
    var listButtonTapped: ControlEvent<Void> {
        return base.listButtonTapped
    }
}

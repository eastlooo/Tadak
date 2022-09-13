//
//  TadakMainBackgroundView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit

final class TadakMainBackgroundView: UIView {

    // MARK: Properties
    private let behindRightView = UIView()
    private let topRoundedView = UIView()
    private let bottomRoundedView = UIView()

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
        self.backgroundColor = .white
        behindRightView.backgroundColor = .customNavy
        topRoundedView.backgroundColor = .white
        bottomRoundedView.backgroundColor = .customNavy
    }

    private func layout() {
        topRoundedView.layer.cornerRadius = 80
        topRoundedView.layer.maskedCorners = .layerMaxXMaxYCorner
        bottomRoundedView.layer.cornerRadius = 80
        bottomRoundedView.layer.maskedCorners = .layerMinXMinYCorner

        self.addSubview(behindRightView)
        behindRightView.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalTo(self.snp.centerX)
        }

        self.addSubview(topRoundedView)
        topRoundedView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(self.snp.centerY).offset(30)
        }

        self.addSubview(bottomRoundedView)
        bottomRoundedView.snp.makeConstraints {
            $0.top.equalTo(topRoundedView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

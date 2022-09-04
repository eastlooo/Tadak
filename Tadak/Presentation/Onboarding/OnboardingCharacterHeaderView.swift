//
//  OnboardingCharacterHeaderView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit
import SnapKit

final class OnboardingCharacterHeaderView: UICollectionReusableView {
    
    // MARK: Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24.0, weight: .heavy)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        label.numberOfLines = 2
        return label
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
        self.backgroundColor = .customNavy
        
        titleLabel.text = "만나서 반가워요!"
        
        let description = "가장 마음에 드는 캐릭터를\n선택해주세요"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 7
        descriptionLabel.attributedText = NSAttributedString(
            string: description,
            attributes: [
                .font: UIFont.systemFont(ofSize: 18.0, weight: .medium),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
        )
    }
    
    private func layout() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30.0)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(35.0)
            $0.centerX.equalToSuperview()
        }
    }
}

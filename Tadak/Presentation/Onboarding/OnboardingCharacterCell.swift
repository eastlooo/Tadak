//
//  OnboardingCharacterCell.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit

final class OnboardingCharacterCell: UICollectionViewCell {
    
    // MARK: Properties
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = contentView.frame.height / 2
    }
    
    // MARK: Helpers
    private func configure() {
        contentView.backgroundColor = .customLightGray
    }
    
    private func layout() {
        contentView.addSubview(characterImageView)
        characterImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(contentView.snp.height).multipliedBy(0.7)
        }
    }
}

extension OnboardingCharacterCell {
    func bind(_ item: Int) {
        characterImageView.image = UIImage.character(item)
    }
}

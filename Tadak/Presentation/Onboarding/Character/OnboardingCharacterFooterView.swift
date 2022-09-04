//
//  OnboardingCharacterFooterView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit

final class OnboardingCharacterFooterView: UICollectionReusableView {
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .customNavy
    }
}

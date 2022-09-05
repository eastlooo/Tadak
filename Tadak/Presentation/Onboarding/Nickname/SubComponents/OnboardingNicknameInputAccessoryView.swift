//
//  OnboardingNicknameInputAccessoryView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit
import SnapKit

final class OnboardingNicknameInputAccessoryView: UIView {
    
    // MARK: Properties
    private let characterReselectButton: TextButton = {
        let button = TextButton(colorType: .pumpkin)
        button.titleFont = .notoSansKR(ofSize: 16, weight: .bold)
        return button
    }()
    
    private let doneButton: TextButton = {
        let button = TextButton(colorType: .coral)
        button.isEnabled = false
        button.titleFont = .notoSansKR(ofSize: 16, weight: .bold)
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
        
        characterReselectButton.title = "캐릭터 재선택"
        doneButton.title = "시작하기"
    }
    
    private func layout() {
        autoresizingMask = .flexibleHeight
        
        let hStackView = UIStackView(arrangedSubviews: [characterReselectButton, doneButton])
        hStackView.axis = .horizontal
        hStackView.spacing = 18
        hStackView.distribution = .fillEqually
        
        self.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.height.equalTo(50.0)
            $0.left.right.equalToSuperview().inset(18)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-10.0)
        }
    }
}

//
//  TypingDashboard.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/07.
//

import UIKit
import SnapKit

final class TypingDashboard: UIView {
    
    // MARK: Properties
    private let typingSpeedLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansKR(ofSize: 40, weight: .black)
        label.textColor = .customPumpkin
        return label
    }()
    
    private let elapesdTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansKR(ofSize: 22, weight: .black)
        label.textColor = .white
        return label
    }()
    
    private let accuracyLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansKR(ofSize: 22, weight: .black)
        label.textColor = .white
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
        self.backgroundColor = .clear
        
        typingSpeedLabel.text = "496"
        elapesdTimeLabel.text = "00:04"
        accuracyLabel.text = "97%"
    }
    
    private func layout() {
        self.snp.makeConstraints {
            $0.height.equalTo(85)
        }
        
        self.addSubview(typingSpeedLabel)
        typingSpeedLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-3)
        }
        
        let offset = UIScreen.main.bounds.width / 6
        
        self.addSubview(elapesdTimeLabel)
        elapesdTimeLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.snp.left).offset(offset)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(accuracyLabel)
        accuracyLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.snp.right).offset(-offset)
            $0.centerY.equalToSuperview()
        }
    }
}

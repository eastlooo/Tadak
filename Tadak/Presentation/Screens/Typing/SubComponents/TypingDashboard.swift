//
//  TypingDashboard.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/07.
//

import UIKit
import SnapKit
import RxSwift

final class TypingDashboard: UIView {
    
    // MARK: Properties
    var elapsedTime: Int = 0 {
        didSet { updateElapsedTime() }
    }
    
    var accuracy: Int = 0 {
        didSet { accuracyLabel.text = "\(accuracy)%" }
    }
    
    var typingSpeed: Int = 0 {
        didSet { typingSpeedLabel.text = "\(typingSpeed)" }
    }
    
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
        super.init(coder: coder)
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .clear
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
    
    private func updateElapsedTime() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        let text = formatter.string(from: TimeInterval(elapsedTime))
        elapesdTimeLabel.text = text
    }
}

// MARK: - Binder
extension Reactive where Base: TypingDashboard {
    
    var elapsedTime: Binder<Int> {
        return Binder(base) { base, value in
            base.elapsedTime = value
        }
    }
    
    var accuracy: Binder<Int> {
        return Binder(base) { base, value in
            base.accuracy = value
        }
    }
    
    var typingSpeed: Binder<Int> {
        return Binder(base) { base, value in
            base.typingSpeed = value
        }
    }
}

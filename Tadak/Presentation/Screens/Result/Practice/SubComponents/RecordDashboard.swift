//
//  RecordDashboard.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/23.
//

import UIKit
import RxSwift

final class RecordDashboard: UIStackView {
    
    // MARK: Properties
    var record: Record? {
        didSet { updateRecord() }
    }
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "시간(초)"
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 15, weight: .black)
        return label
    }()
    
    private let timeRecordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customCoral
        label.font = .notoSansKR(ofSize: 32, weight: .black)
        return label
    }()
    
    private let speedLabel: UILabel = {
        let label = UILabel()
        label.text = "평균타수"
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 15, weight: .black)
        return label
    }()
    
    private let speedRecordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customCoral
        label.font = .notoSansKR(ofSize: 32, weight: .black)
        return label
    }()
    
    private let accuracyLabel: UILabel = {
        let label = UILabel()
        label.text = "정확도(%)"
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 15, weight: .black)
        return label
    }()
    
    private let accuracyRecordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customCoral
        label.font = .notoSansKR(ofSize: 32, weight: .black)
        return label
    }()
    
    // MARK: Lifecycle
    init() {
        super.init(frame: .zero)
        
        configure()
        layout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.axis = .horizontal
        self.spacing = 0
        self.distribution = .fillEqually
        self.alignment = .center
    }
    
    private func layout() {
        let timeStackView = Self.vStackView(arrangedSubviews: [timeLabel, timeRecordLabel])
        let speedStackView = Self.vStackView(arrangedSubviews: [speedLabel, speedRecordLabel])
        let accuracyStackView = Self.vStackView(arrangedSubviews: [accuracyLabel, accuracyRecordLabel])
        
        for stackView in [timeStackView, speedStackView, accuracyStackView] {
            self.addArrangedSubview(stackView)
        }
    }
    
    private func updateRecord() {
        timeRecordLabel.text = record.map { "\($0.elapsedTime)" }
        speedRecordLabel.text = record.map { "\($0.typingSpeed)" }
        accuracyRecordLabel.text = record.map { "\($0.accuracy)" }
    }
    
    // MARK: Components
    private static func vStackView(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = -7
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        return stackView
    }
}

// MARK: Rx+Extension
extension Reactive where Base: RecordDashboard {
    
    // MARK: Binder
    var record: Binder<Record> {
        return Binder(base) { base, value in
            base.record = value
        }
    }
}

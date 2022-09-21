//
//  ComposeParticipantsHeaderView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ComposeParticipantsHeaderView: UIView {
    
    // MARK: Properties
    var minimumNumber: Int = 0
    
    var maximumNumber: Int = 2 {
        didSet { updateDescription() }
    }
    
    var currentNumber: Int = 1 {
        didSet { updateNumber() }
    }
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 80, weight: .black)
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 16, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let minusButton = ComposeParticipantsNumberButton(type: .minus)
    fileprivate let plusButton = ComposeParticipantsNumberButton(type: .plus)
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func layout() {
        let hStackView = UIStackView(arrangedSubviews: [
            minusButton, numberLabel, plusButton
        ])
        hStackView.axis = .horizontal
        hStackView.distribution = .fillProportionally
        hStackView.spacing = -5
        hStackView.alignment = .bottom
        
        let vStackView = UIStackView(arrangedSubviews: [hStackView, descriptionLabel])
        vStackView.axis = .vertical
        vStackView.distribution = .fillProportionally
        vStackView.spacing = 15
        vStackView.alignment = .center
        
        self.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(0)
        }
        
        numberLabel.snp.makeConstraints {
            $0.height.equalTo(84)
        }
    }
    
    private func updateDescription() {
        descriptionLabel.text = "인원 수를 선택해주세요\n *최대 \(maximumNumber)명*"
    }
    
    private func updateNumber() {
        numberLabel.text = "\(currentNumber)"
        minusButton.isEnabled = (minimumNumber != currentNumber)
        plusButton.isEnabled = (maximumNumber != currentNumber)
    }
}

// MARK: - Rx+Extension
extension Reactive where Base: ComposeParticipantsHeaderView {
    
    // MARK: Binder
    var minimumNumber: Binder<Int> {
        return Binder(base) { base, value in
            base.minimumNumber = value
        }
    }
    
    var maximumNumber: Binder<Int> {
        return Binder(base) { base, value in
            base.maximumNumber = value
        }
    }
    
    var currentNumber: Binder<Int> {
        return Binder(base) { base, value in
            base.currentNumber = value
        }
    }
    
    // MARK: ControlEvent
    var plusButtonTapped: ControlEvent<Void> {
        return base.plusButton.rx.tap
    }
    
    var minusButtonTapped: ControlEvent<Void> {
        return base.minusButton.rx.tap
    }
}

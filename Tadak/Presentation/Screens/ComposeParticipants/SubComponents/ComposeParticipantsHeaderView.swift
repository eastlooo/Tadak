//
//  ComposeParticipantsHeaderView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit

final class ComposeParticipantsHeaderView: UIView {
    
    // MARK: Properties
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "2"
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 80, weight: .black)
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
    
    private let minusButton = ComposeParticipantsNumberButton(type: .minus)
    private let plusButton = ComposeParticipantsNumberButton(type: .plus)
    
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
        descriptionLabel.text = "인원 수를 선택해주세요\n (2~8 명)"
        
        minusButton.isEnabled = false
    }
    
    private func layout() {
        let hStackView = UIStackView(arrangedSubviews: [
            minusButton, numberLabel, plusButton
        ])
        hStackView.axis = .horizontal
        hStackView.distribution = .fillProportionally
        hStackView.spacing = 9
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
            $0.height.equalTo(72)
        }
    }
}

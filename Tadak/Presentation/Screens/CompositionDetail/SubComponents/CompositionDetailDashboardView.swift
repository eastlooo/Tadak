//
//  CompositionDetailDashboardView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit

final class CompositionDetailDashboardView: UIView {
    
    // MARK: Properties
    var score: Int? {
        didSet { updateScore() }
    }
    
    private let rewardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private let highestRecordLabel: UILabel = {
        let label = UILabel()
        label.text = "공식 기록"
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 12, weight: .bold)
        return label
    }()
    
    private let highestRecordValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 30, weight: .black)
        return label
    }()
    
    private lazy var recordStackView: UIStackView = {
        let arrangedSubviews: [UIView] = [highestRecordLabel, highestRecordValueLabel]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = -8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.isHidden = true
        return stackView
    }()
    
    //MARK: Lifecycle
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
        self.backgroundColor = .white.withAlphaComponent(0.05)
    }
    
    private func layout() {
        self.addSubview(rewardImageView)
        rewardImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.right.equalTo(self.snp.centerX)
            $0.width.height.equalTo(44)
        }
        
        self.addSubview(recordStackView)
        recordStackView.snp.makeConstraints {
            $0.left.equalTo(rewardImageView.snp.right).offset(15)
            $0.centerY.equalTo(rewardImageView)
        }
    }
    
    private func updateScore() {
        recordStackView.isHidden = (score == nil)
        rewardImageView.isHidden = (score == nil)
        
        if let score = score {
            highestRecordValueLabel.text = "\(score)"
            rewardImageView.image = UIImage.reward(score: score)
        }
    }
}

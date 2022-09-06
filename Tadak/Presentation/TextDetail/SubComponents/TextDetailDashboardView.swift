//
//  TextDetailDashboardView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit

final class TextDetailDashboardView: UIView {
    
    // MARK: Properties
    var typingMode: TypingMode = .practice {
        didSet { typingModeLabel.text = typingMode.description }
    }
    
    var record: Int? {
        didSet { updateRecord() }
    }
    
    private let topDivider = UIView()
    private let bottomDivider = UIView()
    
    private let rewardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let typingModeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 14, weight: .medium)
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 2
        label.textAlignment = .center
        return label
    }()
    
    private let recordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = -8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var highestRecordLabel: UILabel = {
        let label = UILabel()
        label.text = "최고 기록"
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 14, weight: .bold)
        return label
    }()
    
    private lazy var highestRecordValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 36, weight: .black)
        return label
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
        self.backgroundColor = .customNavy
        topDivider.backgroundColor = .white
        bottomDivider.backgroundColor = .white
        
        rewardImageView.image = .reward(3)
    }
    
    private func layout() {
        self.snp.makeConstraints {
            $0.height.equalTo(122)
        }
        
        self.addSubview(topDivider)
        topDivider.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        self.addSubview(bottomDivider)
        bottomDivider.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        self.addSubview(rewardImageView)
        rewardImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(15)
            $0.width.height.equalTo(70)
        }
        
        typingModeLabel.layer.cornerRadius = 5
        typingModeLabel.layer.cornerCurve = .continuous
        self.addSubview(typingModeLabel)
        typingModeLabel.snp.makeConstraints {
            $0.top.equalTo(rewardImageView)
            $0.right.equalToSuperview().inset(5)
            $0.width.equalTo(82)
            $0.height.equalTo(34)
        }
        
        self.addSubview(recordStackView)
        recordStackView.snp.makeConstraints {
            $0.left.equalTo(rewardImageView.snp.right).offset(10)
            $0.bottom.equalTo(rewardImageView)
        }
    }
    
    private func updateRecord() {
        recordStackView.arrangedSubviews.forEach {
            recordStackView.removeArrangedSubview($0)
        }
        
        guard let record = record else { return }
        highestRecordValueLabel.text = "\(record)"
        recordStackView.addArrangedSubview(highestRecordLabel)
        recordStackView.addArrangedSubview(highestRecordValueLabel)
    }
}

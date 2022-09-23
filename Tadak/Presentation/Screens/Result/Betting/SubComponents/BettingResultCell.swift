//
//  BettingResultCell.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/23.
//

import UIKit

final class BettingResultCell: UITableViewCell {
    
    // MARK: Properties
    private let roundedView = UIView()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .black)
        label.textColor = .white
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .black)
        label.textColor = .customDarkNavy
        return label
    }()
    
    private let speedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 27, weight: .black)
        return label
    }()
    
    private let accuracyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .black)
        label.textColor = .darkGray
        return label
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Helpers
    private func configure() {
        self.selectionStyle = .none
        self.backgroundColor = .white
    }
    
    private func layout() {
        let recordStackView = UIStackView(arrangedSubviews: [speedLabel, accuracyLabel])
        recordStackView.axis = .vertical
        recordStackView.spacing = 0
        recordStackView.alignment = .center
        
        roundedView.layer.cornerRadius = 19
        
        contentView.addSubview(roundedView)
        roundedView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(34)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(38)
        }
        
        roundedView.addSubview(rankLabel)
        rankLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        contentView.addSubview(recordStackView)
        recordStackView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(34)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(roundedView.snp.right).offset(15)
            $0.centerY.equalToSuperview()
            $0.right.lessThanOrEqualTo(recordStackView.snp.left).offset(-10)
        }
    }
    
    private func updatePointColor(_ color: UIColor?) {
        roundedView.backgroundColor = color
        speedLabel.textColor = color
    }
}


// MARK: Bind
extension BettingResultCell {
    
    func bind(with ranking: Rank) {
        rankLabel.text = "\(ranking.order)"
        nameLabel.text = ranking.name
        speedLabel.text = "\(ranking.record.typingSpeed)"
        accuracyLabel.text = " \(ranking.record.accuracy)%"
        
        switch ranking.order {
        case 1: updatePointColor(.customCoral)
        case 2: updatePointColor(.customPumpkin)
        case 3: updatePointColor(.customSkyBlue)
        default: updatePointColor(.customDarkNavy)
        }
    }
}

//
//  TadakListCell.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit

final class TadakListCell: UITableViewCell {
    
    // MARK: Properties
    private let roundedView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansKR(ofSize: 18, weight: .black)
        label.textColor = .white
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansKR(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let rewardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        roundedView.backgroundColor = .customLightNavy
        titleLabel.adjustsFontSizeToFitWidth = true
        artistLabel.adjustsFontSizeToFitWidth = true
        
        rewardImageView.image = UIImage.reward(1)
    }
    
    private func layout() {
        roundedView.layer.cornerRadius = 10
        roundedView.layer.cornerCurve = .continuous
        
        contentView.addSubview(roundedView)
        roundedView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(17)
        }
        
        roundedView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.left.equalToSuperview().inset(24)
        }
        
        roundedView.addSubview(artistLabel)
        artistLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(1)
            $0.left.equalTo(titleLabel)
        }
        
        roundedView.addSubview(rewardImageView)
        rewardImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(20)
            $0.width.height.equalTo(50)
            $0.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(10)
            $0.left.greaterThanOrEqualTo(artistLabel.snp.right).offset(10)
        }
    }
}


// MARK: Bind
extension TadakListCell {
    func bind(with composition: Composition) {
        titleLabel.text = composition.title
        artistLabel.text = composition.artist
    }
}

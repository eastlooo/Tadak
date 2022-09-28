//
//  MyListCell.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit

final class MyListCell: UITableViewCell {
    
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
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        roundedView.backgroundColor = .customLightNavy
        titleLabel.adjustsFontSizeToFitWidth = true
        artistLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func layout() {
        roundedView.layer.cornerRadius = 10
        roundedView.layer.cornerCurve = .continuous
        
        contentView.addSubview(roundedView)
        roundedView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.5)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8.5)
        }
        
        roundedView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.left.equalToSuperview().inset(24)
            $0.right.lessThanOrEqualToSuperview().inset(20)
        }
        
        roundedView.addSubview(artistLabel)
        artistLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(1)
            $0.left.equalTo(titleLabel)
            $0.right.lessThanOrEqualToSuperview().inset(20)
        }
    }
}

// MARK: Bind
extension MyListCell {
    
    func bind(with composition: MyComposition) {
        titleLabel.text = composition.title
        artistLabel.text = composition.artist
    }
}

//
//  SettingCell.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/29.
//

import UIKit

final class SettingCell: UITableViewCell {
    
    // MARK: Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.8)
        label.font = .notoSansKR(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.8)
        label.font = .notoSansKR(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let accessoryImageView: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 16,
                                                        weight: .bold)
        let imge = UIImage(systemName: "chevron.right",
                           withConfiguration: configuration)
        let imageView = UIImageView(image: imge)
        imageView.tintColor = .white.withAlphaComponent(0.5)
        imageView.contentMode = .center
        return imageView
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
        contentView.backgroundColor = .customNavy
    }
    
    private func layout() {
        contentView.addSubview(accessoryImageView)
        accessoryImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(17)
            $0.width.height.equalTo(20)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(25)
            $0.right.lessThanOrEqualTo(accessoryImageView.snp.left)
        }
    }
}

// MARK: Bind
extension SettingCell {
    
    func bind(with setting: Setting) {
        titleLabel.text = setting.title
        subTitleLabel.text = setting.subTitle
        
        subTitleLabel.isHidden = (setting.subTitle == nil)
    }
}

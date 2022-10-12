//
//  SettingTableFooterView.swift
//  Tadak
//
//  Created by 정동천 on 2022/10/12.
//

import UIKit
import SnapKit

final class SettingTableFooterView: UIView {
    
    // MARK: Properties
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = .notoSansKR(ofSize: 16, weight: .regular)
        return label
    }()
    
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
        self.backgroundColor = .clear
        
        let info = Bundle.main.infoDictionary
        let appVersion = info?["CFBundleShortVersionString"] as? String ?? ""
        versionLabel.text = "앱 버전 \(appVersion)"
    }
    
    private func layout() {
        self.addSubview(versionLabel)
        versionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(25)
        }
    }
}

//
//  SettingTableHeaderView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/29.
//

import UIKit
import SnapKit

final class SettingTableHeaderView: UIView {
    
    // MARK: Properties
    private let view = UIView()
    
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
        self.clipsToBounds = false
        self.backgroundColor = .customNavy
        view.backgroundColor = .customNavy
    }
    
    private func layout() {
        self.addSubview(view)
        view.snp.makeConstraints {
            let screenHight = UIScreen.main.bounds.height
            $0.top.equalToSuperview().offset(-screenHight)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

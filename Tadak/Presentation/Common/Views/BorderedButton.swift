//
//  BorderedButton.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit

final class BorderedButton: UIControl {
    
    // MARK: Properties
    var title: String? {
        didSet { titleLabel.text = title }
    }
    
    var titleFont: UIFont? {
        didSet { titleLabel.font = titleFont }
    }
    
    override var isEnabled: Bool {
        didSet { updateButtonState() }
    }
    
    private let titleLabel = UILabel()
    
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
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        
        updateButtonState()
    }
    
    private func layout() {
        self.layer.cornerRadius = 10
        self.layer.cornerCurve = .continuous
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func updateButtonState() {
        titleLabel.textColor = isEnabled ? .white : .customNavy
        self.backgroundColor = isEnabled ? .customNavy : .white
    }
}

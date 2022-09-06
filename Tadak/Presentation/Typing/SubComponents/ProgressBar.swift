//
//  ProgressBar.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/07.
//

import UIKit
import SnapKit

final class ProgressBar: UIView {
    
    // MARK: Properties
    var progression: CGFloat = 0 {
        didSet { updateProgression() }
    }
    
    var indicatorColor: UIColor? {
        didSet { indicator.backgroundColor = indicatorColor }
    }
    
    private let indicator = UIView()
    
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
        self.backgroundColor = .white
        indicator.backgroundColor = .customPumpkin
    }
    
    private func layout() {
        self.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalTo(0)
        }
    }
    
    private func updateProgression() {
        guard progression >= 0, progression <= 1 else { return }
        UIView.animate(withDuration: 0.3) {
            self.indicator.snp.updateConstraints {
                $0.width.equalTo(self.frame.width * self.progression)
            }
            self.layoutIfNeeded()
        }
    }
}

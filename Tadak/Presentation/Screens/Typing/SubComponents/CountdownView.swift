//
//  CountdownView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/07.
//

import UIKit
import SnapKit
import Lottie

final class CountdownView: UIView {
    
    // MARK: Properties
    private let animationView: AnimationView = {
        let animationView = AnimationView(name: "countdown")
        animationView.isHidden = true
        return animationView
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "start"), for: .normal)
        button.addTarget(self, action: #selector(startButtonHandler), for: .touchUpInside)
        return button
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
    
    // MARK: Actions
    @objc
    private func startButtonHandler() {
        startButton.isHidden = true
        animationView.isHidden = false
        animationView.play()
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .customNavy
    }
    
    private func layout() {
        self.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.top.bottom.centerX.equalToSuperview()
        }
        
        self.addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(50)
        }
    }
}

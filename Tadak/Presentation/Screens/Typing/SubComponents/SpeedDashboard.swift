//
//  SpeedDashboard.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/21.
//

import UIKit
import SnapKit
import Lottie
import RxSwift

final class SpeedDashboard: UIView {
    
    // MARK: Properties
    var acceleration: Int = 0 {
        didSet { updateSpeed() }
    }
    
    private let animationView: AnimationView = {
        let configuration = LottieConfiguration(renderingEngine: .coreAnimation)
        let animationView = AnimationView(name: "paperplane", configuration: configuration)
        animationView.loopMode = .repeat(.greatestFiniteMagnitude)
        return animationView
    }()

    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Animations
    private func updateSpeed() {
        let offset = self.frame.width * CGFloat(acceleration) / 1000
        
        UIView.animate(withDuration: 0.3) {
            self.animationView.snp.updateConstraints {
                $0.centerX.equalToSuperview().offset(offset)
            }
            
            self.layoutIfNeeded()
        }
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        animationView.play()
    }
    
    private func layout() {
        self.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(self.snp.height).multipliedBy(1.6)
        }
    }
}

// MARK: - Binder
extension Reactive where Base: SpeedDashboard {
    
    var acceleration: Binder<Int> {
        return Binder(base) { base, value in
            base.acceleration = value
        }
    }
}

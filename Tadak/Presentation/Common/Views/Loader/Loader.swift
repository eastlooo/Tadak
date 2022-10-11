//
//  Loader.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/09.
//

import UIKit
import Lottie

final class Loader: UIView {
    
    // MARK: Properties
    static let shared = Loader()
    
    private var backgroundView: UIView?
    private var loader: AnimationView?
    
    private var backgroundViewColor: UIColor? {
        return .black.withAlphaComponent(0.3)
    }
    
    // MARK: Lifecycle
    convenience private init() {
        self.init(frame: UIScreen.main.bounds)
        self.alpha = 0
    }
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func setup() {
        setupBackground()
        setupLoader()
    }
    
    private func showLoader() {
        guard self.alpha != 1 else { return }
        
        self.alpha = 1
        loader?.alpha = 0
        
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: [.allowUserInteraction, .curveEaseIn]) {
                self.loader?.alpha = 1
                self.loader?.play()
            }
    }
    
    private func hideLoader() {
        guard self.alpha != 0 else { return }
        
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: [.allowUserInteraction, .curveEaseIn]) {
                self.loader?.alpha = 0
            } completion: { _ in
                self.destroyLoader()
                self.alpha = 0
            }
    }
}

// MARK: - Method
extension Loader {
    static func show() {
        DispatchQueue.main.async {
            shared.setup()
            shared.showLoader()
        }
    }
    
    static func dismiss() {
        DispatchQueue.main.async {
            shared.hideLoader()
        }
    }
}

// MARK: - Extra Helpers
private extension Loader {
    
    func setupBackground() {
        guard backgroundView == nil else { return }
        
        let keyWindow = UIWindow.keyWindow ?? UIWindow()
        let backgroundView = UIView(frame: self.bounds)
        self.backgroundView = backgroundView
        keyWindow.addSubview(backgroundView)
        
        backgroundView.backgroundColor = backgroundViewColor
        backgroundView.isUserInteractionEnabled = true
    }
    
    func setupLoader() {
        guard loader == nil else { return }
        
        loader = Self.loader()
        
        let window = UIWindow.keyWindow ?? UIWindow()
        let size = window.bounds.size
        let center = CGPoint(x: size.width/2, y: size.height/2)
        
        loader?.frame.size = CGSize(width: 150, height: 150)
        loader?.center = center
        backgroundView?.addSubview(loader!)
    }
    
    func destroyLoader() {
        loader?.removeFromSuperview()
        loader = nil
        
        backgroundView?.removeFromSuperview()
        backgroundView = nil
    }
    
    static func loader() -> AnimationView {
        let configuration = LottieConfiguration(renderingEngine: .coreAnimation)
        let loader = AnimationView(name: "loader", configuration: configuration)
        loader.loopMode = .repeat(.greatestFiniteMagnitude)
        loader.isUserInteractionEnabled = true
        return loader
    }
}

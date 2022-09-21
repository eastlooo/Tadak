//
//  KeyboardDock.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit
import RxSwift

final class KeyboardDock: UIView {
    
    // MARK: Properties
    private let contentView = UIView()
    private let divider = UIView()
    
    private weak var rootView: UIView?
    private weak var parentView: UIView?
    
    // MARK: Lifecycle
    init(root rootView: UIView, parent parentView: UIView) {
        self.rootView = rootView
        self.parentView = parentView
        super.init(frame: .zero)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .customNavy
        contentView.backgroundColor = .customNavy
        divider.backgroundColor = .white.withAlphaComponent(0.1)
    }
    
    private func layout() {
        guard let rootView = rootView,
              let parentView = parentView else {
            return
        }
        
        parentView.addSubview(self)
        self.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        self.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(parentView.safeAreaLayoutGuide)
            $0.height.equalTo(85)
        }
        
        contentView.addSubview(divider)
        divider.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        contentView.addSubview(rootView)
        rootView.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.left.right.equalToSuperview().inset(24)
            $0.top.bottom.equalToSuperview().inset(15)
        }
    }
}

extension KeyboardDock {
    
    func updateKeyboardHeight(_ height: CGFloat) {
        guard let parentView = parentView else { return }
        let bottomPadding = parentView.safeAreaInsets.bottom
        let bottomOffset = (height == 0) ? 0 : height - bottomPadding
        
        parentView.setNeedsLayout()
        UIView.animate(withDuration: 0.4) {
            self.contentView.snp.updateConstraints {
                $0.bottom.equalTo(parentView.safeAreaLayoutGuide).offset(-bottomOffset)
            }
            
            parentView.layoutIfNeeded()
        }
    }
}

// MARK: - Binder
extension Reactive where Base: KeyboardDock {
    
    var keyboardHeight: Binder<CGFloat> {
        return Binder(base) { base, height in
            base.updateKeyboardHeight(height)
        }
    }
}

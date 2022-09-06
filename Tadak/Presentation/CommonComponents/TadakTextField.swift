//
//  TadakTextField.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit
import SnapKit

final class TadakTextField: UITextField {
    
    // MARK: Properties
    private let appearance: Appearance
    
    
    // MARK: Lifecycle
    init(appearance: Appearance = .light) {
        self.appearance = appearance
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        autocorrectionType = .no
        autocapitalizationType = .none
        spellCheckingType = .no
        
        self.tintColor = appearance.tintColor
        self.textColor = appearance.textColor
        self.backgroundColor = appearance.backgroundColor
        self.contentVerticalAlignment = .center
        self.clipsToBounds = true
        
        self.leftView = textFieldSpacer(padding: 22)
        self.rightView = textFieldSpacer(padding: 22)
        self.leftViewMode = .always
        self.rightViewMode = .always
    }
    
    private func textFieldSpacer(padding width: CGFloat) -> UIView {
        UIView(frame: .init(x: 0, y: 0, width: width, height: 0))
    }
}

extension TadakTextField {
    enum Appearance {
        case dark, light
        
        var backgroundColor: UIColor? {
            switch self {
            case .dark: return .customDarkNavy
            case .light: return .customLightGray
            }
        }
        
        var textColor: UIColor? {
            switch self {
            case .dark: return .white
            case .light: return .customDarkNavy
            }
        }
        
        var tintColor: UIColor? {
            switch self {
            case .dark: return .customPumpkin
            case .light: return .customDarkNavy
            }
        }
    }
}

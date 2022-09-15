//
//  TadakTextField.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TadakTextField: UITextField {
    
    // MARK: Properties
    var isPasteEnabled: Bool = false
    var isEditingEnabled: Bool = true
    var maxLength: Int?
    var shouldReturn: Bool = true
    
    fileprivate let inputString = PublishRelay<String>()
    fileprivate let returnPressed = PublishRelay<Void>()
    
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
    
    // MARK: Events
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return isPasteEnabled && isEditingEnabled
        }
        return super.canPerformAction(action, withSender: sender)
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
        
        self.delegate = self
    }
    
    private func textFieldSpacer(padding width: CGFloat) -> UIView {
        UIView(frame: .init(x: 0, y: 0, width: width, height: 0))
    }
}

// MARK: - UITextFieldDelegate
extension TadakTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isEditingEnabled {
            inputString.accept(string)
        }
        
        if let maxLength = maxLength {
            return (string.count <= maxLength) && isEditingEnabled
        }
        
        return isEditingEnabled
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        returnPressed.accept(Void())
        return shouldReturn
    }
}

// MARK: - Enum
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

// MARK: - Rx+Extension
extension Reactive where Base: TadakTextField {
    
    // MARK: Binder
    var isEditingEnabled: Binder<Bool> {
        return Binder(base) { textField, value in
            textField.isEditingEnabled = value
        }
    }
    
    var maxLength: Binder<Int?> {
        return Binder(base) { textField, value in
            textField.maxLength = value
        }
    }
    
    // MARK: ControlEvent
    var inputString: ControlEvent<String> {
        return ControlEvent(events: base.inputString)
    }
    
    var returnPressed: ControlEvent<Void> {
        return ControlEvent(events: base.returnPressed)
    }
}

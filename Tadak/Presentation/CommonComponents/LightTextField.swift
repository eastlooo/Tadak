//
//  LightTextField.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit
import SnapKit

final class LightTextField: TextField {
    
    // MARK: Properties
    override var placeholder: String? {
        didSet {
            self.attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [
                    .foregroundColor: UIColor.gray
                ]
            )
        }
    }
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.tintColor = .customDarkNavy
        self.textColor = .customDarkNavy
        self.backgroundColor = .customLightGray
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

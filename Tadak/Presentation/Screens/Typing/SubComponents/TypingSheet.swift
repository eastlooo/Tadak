//
//  TypingSheet.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TypingSheet: UIView {
    
    // MARK: Properties
    var typingFont: UIFont
    
    var title: String? {
        didSet { titleLabel.text = title }
    }
    
    var currentTyping: String = "" {
        didSet {
            currentTypingLabel.attributedText = NSAttributedString(
                string: currentTyping,
                attributes: [.font: typingFont, .foregroundColor: UIColor.black, .kern: 0.18])
        }
    }
    
    var nextTyping: String = "" {
        didSet {
            nextTypingLabel.text = nextTyping
            
            nextLabel.isHidden = nextTyping.isEmpty
            nextTypingLabel.isHidden = nextTyping.isEmpty
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customDarkNavy
        label.font = .notoSansKR(ofSize: 22, weight: .black)
        return label
    }()
    
    fileprivate lazy var typingTextField: TadakTextField = {
        let textField = TadakTextField(appearance: .dark)
        textField.isEditingEnabled = false
        textField.defaultTextAttributes.updateValue(0.18, forKey: .kern)
        textField.returnKeyType = .next
        textField.shouldReturn = false
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var currentTypingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let nextLabel: UILabel = {
        let label = UILabel()
        label.text = "Next"
        label.textColor = .darkGray
        label.font = .notoSansKR(ofSize: 18, weight: .black)
        return label
    }()
    
    private lazy var nextTypingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    private lazy var nextStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nextLabel, nextTypingLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    // MARK: Lifecycle
    init(typingFont: UIFont) {
        self.typingFont = typingFont
        super.init(frame: .zero)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func textFieldEditingChanged(_ sender: UITextField) {
        var inputText = sender.text ?? ""
        var currentTyping = currentTyping
        let attributedText = NSMutableAttributedString()
        var attributes: [NSAttributedString.Key: Any] = [
            .font: typingFont, .foregroundColor: UIColor.black, .kern: 0.18
        ]
        var stack = [NSAttributedString]()

        let minimumCount = min(currentTyping.count, inputText.count)
        let index = currentTyping.index(currentTyping.startIndex, offsetBy: minimumCount)
        
        if inputText.count < currentTyping.count {
            let string = String(currentTyping[index...])
            let rest = NSAttributedString(string: string, attributes: attributes)
            stack.append(rest)
        }

        currentTyping = String(currentTyping[..<index])
        
        guard currentTyping.count > 0 else {
            stack.first.map { currentTypingLabel.attributedText = $0 }
            return
        }
        
        let character = currentTyping.removeLast()
        let color: UIColor = (character == inputText.removeLast()) ? .blue
        : .black
        attributes[.foregroundColor] = color
        let lastChar = NSAttributedString(string: String(character), attributes: attributes)
        stack.append(lastChar)
        
        for _ in 0..<currentTyping.count {
            let character = currentTyping.removeLast()
            let color: UIColor = (character == inputText.removeLast()) ? .blue : .red
            attributes[.foregroundColor] = color
            let char = NSAttributedString(string: String(character), attributes: attributes)
            stack.append(char)
        }
        
        for _ in 0..<stack.count {
            attributedText.append(stack.removeLast())
        }

        currentTypingLabel.attributedText = attributedText
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        
        typingTextField.font = typingFont
        currentTypingLabel.font = typingFont
        nextTypingLabel.font = typingFont
    }
    
    private func layout() {
        self.layer.cornerRadius = 45
        self.layer.cornerCurve = .continuous
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.centerX.equalToSuperview()
        }
        
        typingTextField.layer.cornerRadius = 22.5
        self.addSubview(typingTextField)
        typingTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(45)
        }
        
        let offset = typingTextField.leftView?.frame.width ?? 0
        self.addSubview(currentTypingLabel)
        currentTypingLabel.snp.makeConstraints {
            $0.left.equalTo(typingTextField).offset(offset)
            $0.bottom.equalTo(typingTextField.snp.top).offset(-10)
        }
        
        self.addSubview(nextStackView)
        nextStackView.snp.makeConstraints {
            $0.top.equalTo(typingTextField.snp.bottom).offset(16)
            $0.left.right.equalTo(currentTypingLabel)
        }
    }
}

// MARK: - Method
extension TypingSheet {
    override func becomeFirstResponder() -> Bool { typingTextField.becomeFirstResponder() }
    
    func getTextWidth(parentWidth width: CGFloat) -> CGFloat {
        let inset = 20.0
        let padding = typingTextField.leftView?.frame.width ?? 0
        
        return width - 2 * (inset + padding)
    }
}

// MARK: - Rx+Extension
extension Reactive where Base: TypingSheet {
    
    // MARK: Binder
    var title: Binder<String?> {
        return Binder(base) { base, element in
            base.title = element
        }
    }
    
    var currentTyping: Binder<String> {
        return Binder(base) { base, element in
            base.currentTyping = element
        }
    }
    
    var nextTyping: Binder<String> {
        return Binder(base) { base, element in
            base.nextTyping = element
        }
    }
    
    var isTypingEnabled: Binder<Bool> { base.typingTextField.rx.isEditingEnabled }
    
    // MARK: ControlEvent
    var returnPressed: ControlEvent<Void> { base.typingTextField.rx.returnPressed }
    
    // MARK: ControlProperty
    var typing: ControlProperty<String?> { base.typingTextField.rx.text }
}

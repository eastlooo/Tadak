//
//  TypingTextScreen.swift
//  Tadak
//
//  Created by 정동천 on 2022/10/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol TypingTextScreenDelegate: AnyObject {
    
    func textScreenEditingChanged(_ text: String?)
}

final class TypingTextScreen: UIView {
    
    // MARK: Properties
    weak var delegate: TypingTextScreenDelegate?
    
    var isEditingEnabled: Bool = false {
        didSet {
            proxyTextField.isEditingEnabled = isEditingEnabled
        }
    }
    
    var font: UIFont? {
        didSet {
            displayLabel.font = font
            proxyTextField.font = font
        }
    }
    
    var padding: CGFloat { proxyTextField.padding }
    
    private let disposeBag = DisposeBag()
    fileprivate let _displayLabelText = BehaviorSubject<String?>(value: nil)
    fileprivate let _proxyText = BehaviorSubject<String?>(value: nil)
    
    private var displayText: String? {
        didSet { updateDisplayText() }
    }
    
    private var textOffset: Int = 0
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let cursor = UIView()
    
    fileprivate let displayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    fileprivate lazy var proxyTextField: TadakTextField = {
        let textField = TadakTextField()
        textField.isEditingEnabled = false
        textField.isPasteEnabled = false
        textField.isCutEnabled = false
        textField.isCopyEnabled = false
        textField.isSelectEnabled = false
        textField.shouldReturn = false
        textField.returnKeyType = .next
        textField.defaultTextAttributes.updateValue(0.18, forKey: .kern)
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        return textField
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
        bind()
        blinkCursor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        let index = text.index(text.startIndex, offsetBy: textOffset)
        let displayText = "\(text[index...])"
        self.displayText = displayText
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .customNavy
        cursor.backgroundColor = .customPumpkin
        scrollView.isScrollEnabled = false
    }
    
    private func layout() {
        let textStackView = UIStackView(arrangedSubviews: [displayLabel, cursor])
        textStackView.axis = .horizontal
        textStackView.spacing = 0
        textStackView.distribution = .equalSpacing
        textStackView.contentMode = .center
        
        let inset = proxyTextField.padding
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(inset)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        contentView.addSubview(textStackView)
        textStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.lessThanOrEqualToSuperview()
        }
        
        cursor.snp.makeConstraints {
            $0.top.equalTo(self).offset(10)
            $0.bottom.equalTo(self).offset(-10)
            $0.width.equalTo(2)
        }
        
        self.addSubview(proxyTextField)
    }
    
    private func bind() {
        _proxyText
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                let proxyText = self.proxyTextField.text ?? ""
                let inputText = text ?? ""
                self.textOffset = proxyText.count - inputText.count
                self.textFieldEditingChanged(self.proxyTextField)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateDisplayText() {
        displayLabel.text = displayText
        _displayLabelText.onNext(displayText)
        delegate?.textScreenEditingChanged(displayText)
        proxyTextField.isDeleteEnabled = !(displayText ?? "").isEmpty
        
        let contentWidth = displayLabel.sizeThatFits(
            CGSize(
                width: .greatestFiniteMagnitude,
                height: displayLabel.frame.height)
        ).width + 2
        
        let x = contentWidth - scrollView.bounds.width
        if x >= 0 {
            scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: false)
        }
        
        blinkCursor()
    }
}

// MARK: Animations
extension TypingTextScreen {
    
    func blinkCursor() {
        let key = "opacity"
        cursor.layer.removeAnimation(forKey: key)
        let animation = CAKeyframeAnimation(keyPath: key)
        animation.values = [1, 1, 0, 0]
        animation.keyTimes = [0, 0.5, 0.51, 1]
        animation.duration = 1.2
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.autoreverses = false
        animation.repeatCount = .greatestFiniteMagnitude
        cursor.layer.add(animation, forKey: key)
    }
}

extension TypingTextScreen {
    
    override func becomeFirstResponder() -> Bool {
        proxyTextField.becomeFirstResponder()
    }
}

// MARK: - Rx+Extensiont
extension Reactive where Base: TypingTextScreen {
    
    // MARK: ControlEvent
    var returnPressed: ControlEvent<Void> {
        base.proxyTextField.rx.returnPressed
    }
    
    // MARK: ControlProperty
    var typing: ControlProperty<String?> {
        let values = base._displayLabelText.asObservable()
        let valueSink = base._proxyText.asObserver()
        return ControlProperty(values: values, valueSink: valueSink)
    }
}

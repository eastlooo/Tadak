//
//  TypingSheet.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/07.
//

import UIKit
import SnapKit

final class TypingSheet: UIView {
    
    // MARK: Properties
    var title: String? {
        didSet { titleLabel.text = title }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customDarkNavy
        label.font = .notoSansKR(ofSize: 22, weight: .black)
        return label
    }()
    
    private let typingTextField: TadakTextField = {
        let textField = TadakTextField(appearance: .dark)
        textField.font = .notoSansKR(ofSize: 18, weight: .medium)
        return textField
    }()
    
    private let currentTypingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .notoSansKR(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let nextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .notoSansKR(ofSize: 18, weight: .black)
        return label
    }()
    
    private let nextTypingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .notoSansKR(ofSize: 18, weight: .medium)
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
        nextLabel.text = "Next"
        
        currentTypingLabel.text = "여름장이란 애시당초에 글러서 해는 아직 중"
        nextTypingLabel.text = "천에 있건만 장판은 벌써 훅훅 볶는다"
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

extension TypingSheet {
    override func becomeFirstResponder() -> Bool {
        typingTextField.becomeFirstResponder()
    }
}

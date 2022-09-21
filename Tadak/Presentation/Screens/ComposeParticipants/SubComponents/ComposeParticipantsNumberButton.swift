//
//  ComposeParticipantsNumberButton.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit

final class ComposeParticipantsNumberButton: UIButton {
    
    // MARK: Properties
    private let buttonStyle: ButtonStyle
    
    override var isEnabled: Bool {
        didSet { updateButtonState() }
    }
    
    private let backgroundView = UIView()
    
    private lazy var buttonImageView: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        let image = UIImage(systemName: self.buttonStyle.rawValue,
                            withConfiguration: configuration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: Lifecycle
    init(type buttonStyle: ButtonStyle) {
        self.buttonStyle = buttonStyle
        super.init(frame: .zero)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        updateButtonState()
        backgroundView.isUserInteractionEnabled = false
        buttonImageView.isUserInteractionEnabled = false
    }
    
    private func layout() {
        self.snp.makeConstraints {
            $0.width.height.equalTo(60)
        }
        
        backgroundView.layer.cornerRadius = 15
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        backgroundView.addSubview(buttonImageView)
        buttonImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func updateButtonState() {
        backgroundView.backgroundColor = isEnabled ? .customCoral : .lightGray
    }
}

extension ComposeParticipantsNumberButton {
    enum ButtonStyle: String {
        case plus, minus
    }
}

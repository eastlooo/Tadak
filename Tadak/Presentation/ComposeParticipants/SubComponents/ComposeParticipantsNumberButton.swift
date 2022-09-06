//
//  ComposeParticipantsNumberButton.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit

final class ComposeParticipantsNumberButton: UIControl {
    
    // MARK: Properties
    private let buttonType: ButtonType
    
    override var isEnabled: Bool {
        didSet { updateButtonState() }
    }
    
    private let backgroundView = UIView()
    
    private lazy var imageView: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        let image = UIImage(systemName: self.buttonType.rawValue, withConfiguration: configuration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: Lifecycle
    init(type buttonType: ButtonType) {
        self.buttonType = buttonType
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
    }
    
    private func layout() {
        self.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }
        
        backgroundView.layer.cornerRadius = 15
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        backgroundView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func updateButtonState() {
        backgroundView.backgroundColor = isEnabled ? .customCoral : .lightGray
    }
}

extension ComposeParticipantsNumberButton {
    enum ButtonType: String {
        case plus, minus
    }
}

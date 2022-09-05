//
//  TextButton.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit
import SnapKit

final class TextButton: UIControl {
    
    // MARK: Properties
    var title: String? {
        didSet { titleLabel.text = title }
    }
    
    var titleFont: UIFont? {
        didSet { titleLabel.font = titleFont }
    }
    
    override var isEnabled: Bool {
        didSet { updateButtonState() }
    }
    
    private let colorType: ColorType
    private let hasAccessory: Bool
    
    private let titleLabel = UILabel()
    
    private lazy var accessoryImageView: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold)
        let image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    // MARK: Lifecycle
    init(colorType: ColorType, hasAccessory: Bool = false) {
        self.colorType = colorType
        self.hasAccessory = hasAccessory
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
        self.layer.cornerRadius = 12
        self.layer.cornerCurve = .continuous
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        if hasAccessory {
            self.addSubview(accessoryImageView)
            accessoryImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().inset(16)
            }
        }
    }
    
    private func updateButtonState() {
        titleLabel.textColor = isEnabled ? .white : .darkGray
        self.backgroundColor = isEnabled ? colorType.color : .lightGray
    }
}

extension TextButton {
    enum ColorType {
        case pumpkin, coral
        
        var color: UIColor? {
            switch self {
            case .pumpkin: return .customPumpkin
            case .coral: return .customCoral
            }
        }
    }
}

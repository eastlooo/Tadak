//
//  CharacterHelperView.swift
//  Tadak
//
//  Created by 정동천 on 2022/10/13.
//

import UIKit
import SnapKit

final class CharacterHelperView: UIView {
    
    // MARK: Properties
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansKR(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let tooltipView = drawTooltipView()
    
    // MARK: Lifecycle
    init() {
        super.init(frame: .zero)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .clear
        tooltipView.backgroundColor = .white
        
        messageLabel.text = "시작 버튼을 눌러주세요!"
        
        tooltipView.alpha = 0
        messageLabel.alpha = 0
    }
    
    private func layout() {
        self.addSubview(tooltipView)
        tooltipView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
        
        tooltipView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        self.addSubview(characterImageView)
        characterImageView.snp.makeConstraints {
            $0.top.equalTo(tooltipView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(140)
        }
    }
    
    private static func drawTooltipView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        
        let width: CGFloat = 10
        let height: CGFloat = 10
        
        let centerX: CGFloat = 100
        let startX: CGFloat = centerX - (width / 2)
        let endX: CGFloat = startX + width
        
        let startY: CGFloat = 40
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: centerX, y: startY + height))
        path.addLine(to: CGPoint(x: endX, y: startY))
        path.addLine(to: CGPoint(x: 0, y: startY))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.white.cgColor
        
        view.layer.insertSublayer(shape, at: 0)
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 20
        
        return view
    }
}

extension CharacterHelperView {
    
    func setCharacterID(_ id: Int) {
        characterImageView.image = UIImage.character(id)
    }
    
    func showDescription() {
        self.tooltipView.isHidden = false
        self.messageLabel.isHidden = false
        
        UIView.animate(withDuration: 0.4) {
            self.tooltipView.alpha = 1
            self.messageLabel.alpha = 1
        }
    }
    
    func hideDescription() {
        UIView.animate(withDuration: 0.4) {
            self.tooltipView.alpha = 0
            self.messageLabel.alpha = 0
        } completion: { _ in
            self.tooltipView.isHidden = true
            self.messageLabel.isHidden = true
        }
    }
}

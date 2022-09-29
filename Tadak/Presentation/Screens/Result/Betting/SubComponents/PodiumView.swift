//
//  PodiumView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/23.
//

import UIKit

final class PodiumView: UIView {
    
    // MARK: Properties
    let rank: Rank
    
    private let prizeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: Lifecycle
    init(rank: Rank) {
        self.rank = rank
        super.init(frame: .zero)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure(){
        self.clipsToBounds = true
        self.backgroundColor = rank.matchedColor
        prizeImageView.image = UIImage(named: "winner-\(rank.rawValue)")
    }
    
    private func layout() {
        self.layer.cornerRadius = 10
        self.layer.cornerCurve = .continuous
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        self.addSubview(prizeImageView)
        prizeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(50)
        }
    }
}

extension PodiumView {
    
    enum Rank: String {
        case first, second, third
        
        var matchedColor: UIColor? {
            switch self {
            case .first: return .customCoral
            case .second: return .customPumpkin
            case .third: return .customSkyBlue
            }
        }
    }
}

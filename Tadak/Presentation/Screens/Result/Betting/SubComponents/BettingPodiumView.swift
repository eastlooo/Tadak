//
//  BettingPodiumView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/23.
//

import UIKit
import SnapKit

final class BettingPodiumView: UIStackView {
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.axis = .horizontal
        self.distribution = .fillProportionally
        self.alignment = .bottom
    }
    
    // MARK: Components
    private static func nameLabel(_ name: String) -> UILabel {
        let label = UILabel()
        label.text = name
        label.font = .notoSansKR(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }
    
    private static func podiumView(rank: PodiumView.Rank) -> PodiumView {
        let width = UIScreen.main.bounds.width / 4
        var height: CGFloat = 0
        
        switch rank {
        case .first: height = width * 1.6
        case .second: height = width * 1.15
        case .third: height = width * 0.7
        }
        
        let podium = PodiumView(rank: rank)
        
        podium.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
        
        return podium
    }
    
    private static func vStackView(name: String, rank: PodiumView.Rank) -> UIStackView {
        let label = nameLabel(name)
        let podium = podiumView(rank: rank)
        let stackView = UIStackView(arrangedSubviews: [label, podium])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        return stackView
    }
}

extension BettingPodiumView {
    
    func setPodium(first: String, second: String) {
        self.spacing = 25
        
        for arrangedSubview in self.arrangedSubviews {
            self.removeArrangedSubview(arrangedSubview)
        }
        
        let first = Self.vStackView(name: first, rank: .first)
        let second = Self.vStackView(name: second, rank: .second)
        
        for view in [first, second] {
            self.addArrangedSubview(view)
        }
    }
    
    func setPodium(first: String, second: String, third: String) {
        self.spacing = 15
        
        for arrangedSubview in self.arrangedSubviews {
            self.removeArrangedSubview(arrangedSubview)
        }
        
        let first = Self.vStackView(name: first, rank: .first)
        let second = Self.vStackView(name: second, rank: .second)
        let third = Self.vStackView(name: third, rank: .third)
        
        for view in [second, first, third] {
            self.addArrangedSubview(view)
        }
    }
}

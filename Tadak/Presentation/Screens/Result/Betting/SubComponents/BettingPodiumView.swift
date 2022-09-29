//
//  BettingPodiumView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/23.
//

import UIKit
import SnapKit

final class BettingPodiumView: UIView {
    
    // MARK: Properties
    private var first: String?
    private var second: String?
    private var third: String?
    
    private lazy var firstNameLabel = nameLabel()
    private lazy var secondNameLabel = nameLabel()
    private lazy var thirdNameLabel = nameLabel()
    
    private lazy var firstPodiumView = PodiumView(rank: .first)
    private lazy var secondPodiumView = PodiumView(rank: .second)
    private lazy var thirdPodiumView = PodiumView(rank: .third)
    
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
        self.backgroundColor = .customNavy
    }
    
    private func layout() {
        
    }
    
    // MARK: Components
    private func nameLabel() -> UILabel {
        let label = UILabel()
        label.font = .notoSansKR(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.isHidden = true
        return label
    }
    
    private func containerView(label: UILabel, podium: PodiumView) -> UIView {
        let containerView = UIView()
        containerView.clipsToBounds = false
        
        containerView.addSubview(podium)
        podium.snp.makeConstraints {
            let width = UIScreen.main.bounds.width / 4
            $0.left.bottom.right.equalToSuperview()
            $0.width.equalTo(width)
            $0.height.equalTo(0)
        }
        
        containerView.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(podium.snp.top).offset(-4)
        }
        
        return containerView
    }
}

extension BettingPodiumView {
    
    func setPodium(first: String, second: String) {
        let spacing = 25
        
        self.first = first
        self.second = second
        
        firstNameLabel.text = first
        secondNameLabel.text = second
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        let firstContainer = containerView(label: firstNameLabel, podium: firstPodiumView)
        let secondContainer = containerView(label: secondNameLabel, podium: secondPodiumView)
        
        self.addSubview(firstContainer)
        firstContainer.snp.makeConstraints {
            $0.left.bottom.equalToSuperview()
        }
        
        self.addSubview(secondContainer)
        secondContainer.snp.makeConstraints {
            $0.left.equalTo(firstContainer.snp.right).offset(spacing)
            $0.bottom.right.equalToSuperview()
        }
    }
    
    func setPodium(first: String, second: String, third: String) {
        let spacing = 15
        
        self.first = first
        self.second = second
        self.third = third
        
        firstNameLabel.text = first
        secondNameLabel.text = second
        thirdNameLabel.text = third
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        let firstContainer = containerView(label: firstNameLabel, podium: firstPodiumView)
        let secondContainer = containerView(label: secondNameLabel, podium: secondPodiumView)
        let thirdContainer = containerView(label: thirdNameLabel, podium: thirdPodiumView)
        
        self.addSubview(secondContainer)
        secondContainer.snp.makeConstraints {
            $0.left.bottom.equalToSuperview()
        }
        
        self.addSubview(firstContainer)
        firstContainer.snp.makeConstraints {
            $0.left.equalTo(secondContainer.snp.right).offset(spacing)
            $0.bottom.equalToSuperview()
        }
        
        self.addSubview(thirdContainer)
        thirdContainer.snp.makeConstraints {
            $0.left.equalTo(firstContainer.snp.right).offset(spacing)
            $0.bottom.right.equalToSuperview()
        }
    }
}

// MARK: Animations
extension BettingPodiumView {
    
    func animateShow(completion: @escaping() -> Void) {
        let hasThird = (third != nil)
        
        let width = UIScreen.main.bounds.width / 4
        let firstHeight = width * 1.6
        let secondHeight = width * 1.15
        let thirdHeight = width * 0.75
        
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 1.2) {
            self.firstPodiumView.snp.updateConstraints {
                $0.height.equalTo(firstHeight)
            }
            
            self.layoutIfNeeded()
            
        } completion: { _ in
            self.firstNameLabel.isHidden = false
            UIView.animate(withDuration: 1.2) {
                self.secondPodiumView.snp.updateConstraints {
                    $0.height.equalTo(secondHeight)
                }
                
                self.layoutIfNeeded()
                
            } completion: { _ in
                self.secondNameLabel.isHidden = false
                guard hasThird else {
                    completion()
                    return
                }
                
                UIView.animate(withDuration: 1.2) {
                    self.thirdPodiumView.snp.updateConstraints {
                        $0.height.equalTo(thirdHeight)
                    }
                    
                    self.layoutIfNeeded()
                    
                } completion: { _ in
                    self.thirdNameLabel.isHidden = false
                    completion()
                }
            }
        }
    }
}

//
//  PracticeResultCell.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/23.
//

import UIKit

final class PracticeResultCell: UITableViewCell {
    
    // MARK: Properties
    private let font: UIFont = .notoSansKR(ofSize: 18, weight: .bold)!
    
    private let roundedView = UIView()
    private let scrollView = UIScrollView()
    private let originalTextLabel = UILabel()
    private let userTextLabel = UILabel()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Helpers
    private func configure() {
        self.selectionStyle = .none
        self.backgroundColor = .white
        roundedView.backgroundColor = .customDarkNavy
        scrollView.isScrollEnabled = true
    }
    
    private func layout() {
        roundedView.layer.cornerRadius = 22.5
        
        contentView.addSubview(roundedView)
        roundedView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.centerY).offset(3)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(45)
        }
        
        roundedView.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
        }
        
        scrollView.addSubview(userTextLabel)
        userTextLabel.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        
        contentView.addSubview(originalTextLabel)
        originalTextLabel.snp.makeConstraints {
            $0.left.equalTo(scrollView)
            $0.bottom.equalTo(scrollView.snp.top).offset(-5)
        }
    }
}


// MARK: Bind
extension PracticeResultCell {
    
    func bind(originalText: String, userText: String) {
        var originalText = originalText
        var userText = userText
        
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white,
            .kern: 0.18
        ]
        
        userTextLabel.attributedText = NSAttributedString(string: userText, attributes: attributes)
        
 
        
        
            
        let attributedText = NSMutableAttributedString()
        var stack = [NSAttributedString]()

        let minimumCount = min(originalText.count, userText.count)
        let index = originalText.index(originalText.startIndex, offsetBy: minimumCount)

        if userText.count < originalText.count {
            let string = String(originalText[index...])
            attributes[.foregroundColor] = UIColor.red
            let rest = NSAttributedString(string: string, attributes: attributes)
            stack.append(rest)
        }

        originalText = String(originalText[..<index])

        guard originalText.count > 0 else {
            stack.first.map { originalTextLabel.attributedText = $0 }
            return
        }

        for _ in 0..<originalText.count {
            let character = originalText.removeLast()
            let color: UIColor = (character == userText.removeLast()) ? .black : .red
            attributes[.foregroundColor] = color
            let char = NSAttributedString(string: String(character), attributes: attributes)
            stack.append(char)
        }

        for _ in 0..<stack.count {
            attributedText.append(stack.removeLast())
        }

        originalTextLabel.attributedText = attributedText
    }
}

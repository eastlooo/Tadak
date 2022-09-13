//
//  ScrollView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/14.
//

import UIKit

final class ScrollView: UIScrollView {
    
    // MARK: Properties
    private lazy var gestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(tapGestureHandler)
    )
    
    // MARK: Lifecycle
    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Actions
    @objc
    private func tapGestureHandler() {
        self.endEditing(true)
    }
    
    // MARK: Helpers
    private func configure() {
        self.addGestureRecognizer(gestureRecognizer)
    }
}

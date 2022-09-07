//
//  TadakInputAccessoryView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit

final class TadakInputAccessoryView: UIView {
    
    // MARK: Properties
    private let rootView: UIView
    
    private let contentView = UIView()
    private let divider = UIView()
    
    // MARK: Lifecycle
    init(rootView: UIView) {
        self.rootView = rootView
        let width = UIScreen.main.bounds.width
        let frame = CGRect(x: 0, y: 0, width: width, height: 85)
        super.init(frame: frame)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .customNavy
        contentView.backgroundColor = .customNavy
        divider.backgroundColor = .darkGray
    }
    
    private func layout() {
        autoresizingMask = .flexibleHeight
        
        self.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.addSubview(divider)
        divider.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        contentView.addSubview(rootView)
        rootView.snp.makeConstraints {
            $0.height.equalTo(55.0)
            $0.left.right.equalToSuperview().inset(24)
            $0.top.bottom.equalToSuperview().inset(15)
        }
    }
}

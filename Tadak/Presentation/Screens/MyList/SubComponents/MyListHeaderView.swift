//
//  MyListHeaderView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyListHeaderView: UIView {
    
    // MARK: Properties
    fileprivate let addButton = UIButton()
    private let circleBackgroundView = UIView()
    
    private let plusImageView: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold)
        let image = UIImage(systemName: "plus", withConfiguration: configuration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        return imageView
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .clear
        addButton.backgroundColor = .customDarkCloud
        circleBackgroundView.backgroundColor = .customNavy
        circleBackgroundView.isUserInteractionEnabled = false
    }
    
    private func layout() {
        addButton.layer.cornerRadius = 10
        addButton.layer.cornerCurve = .continuous
        
        circleBackgroundView.layer.cornerRadius = 22
        
        self.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(17)
        }
        
        addButton.addSubview(circleBackgroundView)
        circleBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        circleBackgroundView.addSubview(plusImageView)
        plusImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension Reactive where Base: MyListHeaderView {
    
    var addButtonTapped: ControlEvent<Void> { base.addButton.rx.tap }
}

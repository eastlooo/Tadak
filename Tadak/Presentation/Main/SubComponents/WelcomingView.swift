//
//  WelcomingView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import UIKit
import SnapKit
import RxSwift

final class WelcomingView: UIView {
    
    // MARK: Properties
    var user: TadakUser? {
        didSet {
            updateUser()
        }
    }

    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.character(5)
        return imageView
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요!"
        label.font = .notoSansKR(ofSize: 20, weight: .medium)
        label.textColor = .customNavy
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansKR(ofSize: 26, weight: .black)
        label.textColor = .customNavy
        return label
    }()
    
    private let honorificLabel: UILabel = {
        let label = UILabel()
        label.text = "님"
        label.font = .notoSansKR(ofSize: 23, weight: .bold)
        label.textColor = .customNavy
        return label
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Helpers
    private func layout() {
        let nicknameStackView = UIStackView(arrangedSubviews: [nicknameLabel, honorificLabel])
        nicknameStackView.axis = .horizontal
        nicknameStackView.spacing = 3
        nicknameStackView.distribution = .fillProportionally
        nicknameStackView.alignment = .bottom
        
        let welcomeStackView = UIStackView(arrangedSubviews: [welcomeLabel, nicknameStackView])
        welcomeStackView.axis = .vertical
        welcomeStackView.spacing = 0
        welcomeStackView.distribution = .fillProportionally
        welcomeStackView.alignment = .center
        
        self.addSubview(welcomeStackView)
        welcomeStackView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
        }
        
        self.addSubview(characterImageView)
        characterImageView.snp.makeConstraints {
            $0.top.equalTo(welcomeStackView.snp.bottom).offset(10)
            $0.centerX.bottom.equalToSuperview()
            $0.width.height.equalTo(180)
        }
    }
    
    private func updateUser() {
        guard let user = user else { return }
        characterImageView.image = .character(user.characterID)
        nicknameLabel.text = user.nickname
    }
}

extension Reactive where Base: WelcomingView {
    var user: Binder<TadakUser> {
        return Binder(base) { base, user in
            base.user = user
        }
    }
}

//
//  InitializationViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import UIKit
import SnapKit

final class InitializationViewController: UIViewController {
    
    // MARK: Properties
    private let backgroundView = TadakMainBackgroundView()
    private let welcomingView = WelcomingView()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo.png")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
    }
    
    // MARK: Helpers
    private func configure() {
        welcomingView.user = .init(id: "", nickname: "꼬부기", characterID: 5)
    }
    
    private func layout() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.equalToSuperview().inset(28)
            $0.width.equalTo(93)
            $0.height.equalTo(24)
        }
        
        view.addSubview(welcomingView)
        welcomingView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.snp.centerY).offset(70)
        }
    }
}

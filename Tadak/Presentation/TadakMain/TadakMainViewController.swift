//
//  TadakMainViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit
import SnapKit

final class TadakMainViewController: UIViewController {
    
    // MARK: Properties
    private let backgroundView = TadakMainBackgroundView()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo.png")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "gear_fill"), for: .normal)
        button.tintColor = .customNavy
        return button
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.character(5)
        return imageView
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
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
        label.font = .notoSansKR(ofSize: 23, weight: .bold)
        label.textColor = .customNavy
        return label
    }()
    
    private let tadakListButton: TextButton = {
        let button = TextButton(colorType: .pumpkin, hasAccessory: true)
        button.titleFont = .notoSansKR(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let myListButton: TextButton = {
        let button = TextButton(colorType: .coral, hasAccessory: true)
        button.titleFont = .notoSansKR(ofSize: 20, weight: .bold)
        return button
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
        welcomeLabel.text = "안녕하세요!"
        honorificLabel.text = "님"
        nicknameLabel.text = "꼬부기"
        tadakListButton.title = "글 보러가기"
        myListButton.title = "나만의 공간"
    }
    
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
        
        let buttonStackView = UIStackView(arrangedSubviews: [tadakListButton, myListButton])
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 12
        buttonStackView.distribution = .fillEqually
        
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
        
        view.addSubview(settingButton)
        settingButton.snp.makeConstraints {
            $0.centerY.equalTo(logoImageView)
            $0.right.equalToSuperview().inset(15)
            $0.width.height.equalTo(44)
        }
        
        view.addSubview(characterImageView)
        characterImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.width.height.equalTo(180)
        }
        
        view.addSubview(welcomeStackView)
        welcomeStackView.snp.makeConstraints {
            $0.bottom.equalTo(characterImageView.snp.top).offset(-10)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.height.equalTo(122)
        }
    }
}

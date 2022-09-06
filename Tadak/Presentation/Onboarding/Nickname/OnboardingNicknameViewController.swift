//
//  OnboardingNicknameViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit
import SnapKit

final class OnboardingNicknameViewController: UIViewController {
    
    // MARK: Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 26.0, weight: .bold)
        return label
    }()
    
    private let characterButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let textField: LightTextField = {
        let textField = LightTextField()
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 24.0, weight: .semibold)
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 16.0, weight: .regular)
        return label
    }()
    
    private let registerButton: TextButton = {
        let button = TextButton(colorType: .coral)
        button.titleFont = .notoSansKR(ofSize: 20, weight: .bold)
        return button
    }()
    
    private lazy var accessoryView: TadakInputAccessoryView = {
        let accessoryView = TadakInputAccessoryView(rootView: registerButton)
        return accessoryView
    }()
    
    override var inputAccessoryView: UIView? { accessoryView }
    override var canBecomeFirstResponder: Bool { true }
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .customNavy
        contentView.backgroundColor = .customNavy
        
        titleLabel.text = "별명짓기"
        descriptionLabel.text = "별명을 입력해주세요 (2~6 글자)"
        registerButton.title = "등록하기"
        characterButton.setImage(UIImage.character(11), for: .normal)
    }
    
    private func layout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
        }
        
        contentView.addSubview(characterButton)
        characterButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(150)
        }
        
        textField.layer.cornerRadius = 25
        contentView.addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.equalTo(characterButton.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(230)
            $0.height.equalTo(50)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}

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
        label.font = .systemFont(ofSize: 26.0, weight: .black)
        return label
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    
    private let accessoryView: OnboardingNicknameInputAccessoryView = {
        let width = UIScreen.main.bounds.width
        let frame = CGRect(x: 0, y: 0, width: width, height: 70)
        let accessoryView = OnboardingNicknameInputAccessoryView(frame: frame)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _ = textField.becomeFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.textField.resignFirstResponder()
        }
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .customNavy
        contentView.backgroundColor = .customNavy
        
        titleLabel.text = "별명짓기"
        descriptionLabel.text = "2~6자의 한글을 입력해주세요"
        characterImageView.image = UIImage.character(11)
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
        
        contentView.addSubview(characterImageView)
        characterImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(150)
        }
        
        textField.layer.cornerRadius = 25
        contentView.addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.equalTo(characterImageView.snp.bottom).offset(20)
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

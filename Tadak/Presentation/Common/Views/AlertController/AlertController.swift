//
//  AlertController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AlertController: UIViewController {
    
    // MARK: Properties
    var alertTitle: String? {
        didSet { titleLabel.text = alertTitle }
    }
    
    var alertMessage: String? {
        didSet { messageLabel.text = alertMessage }
    }
    
    var autoDismissMode: Bool = true
    
    private var defaultAlertAction: AlertAction?
    private var cancelAlertAction: AlertAction?
    private var defaultButtonActionHandler: ((AlertAction) -> Void)?
    private var cancelButtonActionHandler: ((AlertAction) -> Void)?
    
    private let maxDimmedAlpha: CGFloat = 0.3
    
    private let dimmedView: UIView = {
        let dimmedView = UIView()
        dimmedView.backgroundColor = .black
        dimmedView.alpha = 0
        return dimmedView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12.0
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customCoral
        label.font = .notoSansKR(ofSize: 22.0, weight: .black)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customDarkNavy
        label.font = .notoSansKR(ofSize: 18.0, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    fileprivate lazy var defaultButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customCoral
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .notoSansKR(ofSize: 16, weight: .medium)
        return button
    }()
    
    fileprivate lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .notoSansKR(ofSize: 16, weight: .medium)
        return button
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if flag {
            UIView.animate(withDuration: 0.1) {
                self.containerView.isHidden = true
                self.view.layoutIfNeeded()
            }
            
            dimmedView.alpha = maxDimmedAlpha
            UIView.animate(withDuration: 0.1) {
                self.dimmedView.alpha = 0
            } completion: { _ in
                super.dismiss(animated: false, completion: completion)
            }
        } else {
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
    // MARK: Animations
    private func animateShowDimmedView() {
        UIView.animate(withDuration: 0.1) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
            self.containerView.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .clear
    }
    
    private func layout() {
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(36)
            $0.centerY.equalToSuperview().offset(-50)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.centerX.equalToSuperview()
            $0.left.right.greaterThanOrEqualToSuperview().inset(10)
        }
        
        containerView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.left.right.greaterThanOrEqualToSuperview().inset(10)
        }
        
        containerView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(40)
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(55)
        }
    }
}

extension AlertController {
    
    func addAction(_ action: AlertAction) {
        switch action.style {
        case .default:
            if !buttonStackView.arrangedSubviews.contains(defaultButton) {
                buttonStackView.addArrangedSubview(defaultButton)
                defaultButton.setTitle(action.title, for: .normal)
                
                defaultButton.addAction(UIAction { [weak self] _ in
                    guard let self = self else { return }
                    if self.autoDismissMode {
                        self.dismiss(animated: true) {
                            action.handler?(action)
                        }
                    }
                    
                }, for: .touchUpInside)
            }
            
        case .cancel:
            if !buttonStackView.arrangedSubviews.contains(cancelButton) {
                buttonStackView.addArrangedSubview(cancelButton)
                cancelButton.setTitle(action.title, for: .normal)
                
                cancelButton.addAction(UIAction { [weak self] _ in
                    guard let self = self else { return }
                    if self.autoDismissMode {
                        self.dismiss(animated: true) {
                            action.handler?(action)
                        }
                    }
                    
                }, for: .touchUpInside)
            }
        }
    }
}

// MARK: Rx+Extension
extension Reactive where Base: AlertController {
    
    // MARK: ControlEvent
    var defaultButtonTapped: ControlEvent<Void> {
        return base.defaultButton.rx.tap
    }
    
    var cancelButtonTapped: ControlEvent<Void> {
        return base.cancelButton.rx.tap
    }
}

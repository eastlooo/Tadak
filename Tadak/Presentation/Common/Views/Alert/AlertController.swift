//
//  AlertController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/10.
//

import UIKit
import SnapKit

final class AlertController: UIViewController {
    
    // MARK: Properties
    var alertMessage: String? {
        didSet { messageLabel.text = alertMessage }
    }
    
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
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        return stackView
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customDarkNavy
        label.font = .notoSansKR(ofSize: 18.0, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var defaultButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customCoral
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .notoSansKR(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(defaultButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .notoSansKR(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(defaultButtonHandler), for: .touchUpInside)
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
    
    // MARK: Actions
    @objc
    private func defaultButtonHandler() {
        animateDismissView { [weak self] in
            self?.defaultAlertAction.map {
                self?.defaultButtonActionHandler?($0)
            }
        }
    }
    
    @objc
    private func cancelButtonHandler() {
        animateDismissView { [weak self] in
            self?.cancelAlertAction.map {
                self?.cancelButtonActionHandler?($0)
            }
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
    
    private func animateDismissView(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.1) {
            self.containerView.isHidden = true
            self.view.layoutIfNeeded()
        }
        
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.1) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false) {
                completion?()
            }
        }
    }
    
    // MARK: Helpers
    private func configure() {
        modalPresentationStyle = .overCurrentContext
        
        view.backgroundColor = .clear
        contentStackView.addArrangedSubview(messageLabel)
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
            $0.height.equalTo(160)
        }
        
        containerView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(55)
        }
        
        containerView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(buttonStackView.snp.top)
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
                defaultButtonActionHandler = action.handler
            }
            
        case .cancel:
            if !buttonStackView.arrangedSubviews.contains(cancelButton) {
                buttonStackView.addArrangedSubview(cancelButton)
                cancelButton.setTitle(action.title, for: .normal)
                cancelButtonActionHandler = action.handler
            }
        }
    }
}

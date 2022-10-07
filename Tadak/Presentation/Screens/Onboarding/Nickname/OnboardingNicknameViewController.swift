//
//  OnboardingNicknameViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit
import SnapKit
import ReactorKit
import RxCocoa
import RxKeyboard

final class OnboardingNicknameViewController: UIViewController {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private let scrollView = ScrollView()
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "별명짓기"
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 26.0, weight: .bold)
        return label
    }()
    
    private let characterButton: UIButton = {
        let button = UIButton()
        button.imageEdgeInsets = .init(top: 20, left: 20, bottom: 20, right: 20)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let refreshImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "refresh")
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private let textField: TadakTextField = {
        let textField = TadakTextField()
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 24.0, weight: .semibold)
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "별명을 입력해주세요 (2~6 글자)"
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 16.0, weight: .regular)
        return label
    }()
    
    private let registerButton: TextButton = {
        let button = TextButton(colorType: .coral)
        button.title = "등록하기"
        button.titleFont = .notoSansKR(ofSize: 20, weight: .bold)
        return button
    }()
    
    private lazy var keyboardDock = KeyboardDock(root: registerButton,
                                                 parent: self.view)
    
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
            $0.width.height.equalTo(190)
        }
        
        characterButton.addSubview(refreshImageView)
        refreshImageView.snp.makeConstraints {
            $0.top.left.equalToSuperview()
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
        
        // execute lazy var property
        _ = keyboardDock
    }
}

// MARK: - Bind
extension OnboardingNicknameViewController: View {
    func bind(reactor: OnboardingNicknameViewReactor) {
        
        // MARK: Action
        characterButton.rx.tap
            .map(OnboardingNicknameViewReactor.Action.characterButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        textField.rx.text.orEmpty
            .map(OnboardingNicknameViewReactor.Action.nicknameText)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .map(OnboardingNicknameViewReactor.Action.registerButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.pulse(\.$characterID)
            .map(UIImage.character)
            .bind(to: characterButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$nicknameMaxLength)
            .bind(to: textField.rx.maxLength)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$validate)
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$correctedText)
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$loaderAppear)
            .compactMap { $0 }
            .distinctUntilChanged()
            .bind(to: Loader.rx.show)
            .disposed(by: disposeBag)
        
        // MARK: View
        registerButton.rx.tap
            .bind(to: view.rx.endEditing)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(keyboardDock.rx.keyboardHeight)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                let inset = self.keyboardDock.frame.height
                self.scrollView.contentInset.bottom = inset
                self.scrollView.verticalScrollIndicatorInsets.bottom = inset
            })
            .disposed(by: disposeBag)
    }
}

//
//  TadakMainViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit
import SnapKit
import ReactorKit

final class TadakMainViewController: UIViewController {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private let backgroundView = TadakMainBackgroundView()
    private let welcomingView = WelcomingView()
    
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
    
    private let tadakListButton: TextButton = {
        let button = TextButton(colorType: .pumpkin, hasAccessory: true)
        button.title = "글 보러가기"
        button.titleFont = .notoSansKR(ofSize: 18, weight: .bold)
        return button
    }()
    
    private let myListButton: TextButton = {
        let button = TextButton(colorType: .coral, hasAccessory: true)
        button.title = "나만의 공간"
        button.titleFont = .notoSansKR(ofSize: 18, weight: .bold)
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
    private func configure() {}
    
    private func layout() {
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
        
        view.addSubview(welcomingView)
        welcomingView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.snp.centerY).offset(70)
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
            $0.height.equalTo(122)
        }
    }
}

// MARK: - Bind
extension TadakMainViewController: View {
    func bind(reactor: TadakMainViewReactor) {
        
        // MARK: Action
        self.rx.viewDidAppear
            .map(TadakMainViewReactor.Action.viewDidAppear)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tadakListButton.rx.tap
            .map(TadakMainViewReactor.Action.tadakListButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        myListButton.rx.tap
            .map(TadakMainViewReactor.Action.myListButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        settingButton.rx.tap
            .map(TadakMainViewReactor.Action.settingButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // MARK: State
        reactor.state.map(\.user)
            .bind(to: welcomingView.rx.user)
            .disposed(by: disposeBag)
    }
}

//
//  OfficialSuccessViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/24.
//

import UIKit
import SnapKit
import Lottie
import ReactorKit

final class OfficialSuccessViewController: UIViewController {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private let navigationView = HomeButtonTypeNavigationView()
    private let bottomSheet = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "축하드려요!"
        label.textColor = .customCoral
        label.font = .notoSansKR(ofSize: 26, weight: .black)
        return label
    }()
    
    private let speedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray.withAlphaComponent(0.9)
        label.font = .notoSansKR(ofSize: 48, weight: .bold)
        return label
    }()
    
    private let speedDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "타"
        label.textColor = .darkGray.withAlphaComponent(0.7)
        label.font = .notoSansKR(ofSize: 28, weight: .medium)
        return label
    }()
    
    private let animationView: AnimationView = {
        let configuration = LottieConfiguration(renderingEngine: .coreAnimation)
        let animationView = AnimationView(name: "backgroundprize", configuration: configuration)
        animationView.loopMode = .repeat(.greatestFiniteMagnitude)
        animationView.play()
        return animationView
    }()
    
    private let prizeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let shareButton: TextButton = {
        let button = TextButton(colorType: .coral)
        button.title = "공유하기"
        button.titleFont = .notoSansKR(ofSize: 20, weight: .bold)
        return button
    }()
    
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
        bottomSheet.backgroundColor = .white
        
        navigationView.title = "공식 기록"
        prizeImageView.image = UIImage.reward(4)
    }
    
    private func layout() {
        
        bottomSheet.layer.cornerRadius = 45
        bottomSheet.layer.cornerCurve = .continuous
        bottomSheet.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        
        view.addSubview(bottomSheet)
        bottomSheet.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(5)
            $0.left.right.bottom.equalToSuperview()
        }
        
        bottomSheet.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        bottomSheet.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-50)
            $0.left.right.equalToSuperview().inset(-30)
            $0.height.equalTo(animationView.snp.width)
        }
        
        animationView.addSubview(prizeImageView)
        prizeImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(140)
        }
        
        bottomSheet.addSubview(speedLabel)
        speedLabel.snp.makeConstraints {
            $0.top.equalTo(prizeImageView.snp.bottom).offset(75)
            $0.centerX.equalToSuperview()
        }
        
        bottomSheet.addSubview(speedDescriptionLabel)
        speedDescriptionLabel.snp.makeConstraints {
            $0.left.equalTo(speedLabel.snp.right).offset(2)
            $0.bottom.equalTo(speedLabel).offset(-7)
        }
        
        bottomSheet.addSubview(shareButton)
        shareButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(55)
        }
    }
}

extension OfficialSuccessViewController: View {
    
    func bind(reactor: OfficialSuccessViewReactor) {
        
        // MARK: Action
        navigationView.rx.homeButtonTapped
            .map(OfficialSuccessViewReactor.Action.homeButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
            .map(OfficialSuccessViewReactor.Action.shareButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$tyingSpeed)
            .bind(to: speedLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

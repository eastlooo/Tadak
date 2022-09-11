//
//  InitializationViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/11.
//

import UIKit
import Lottie
import SnapKit
import ReactorKit

final class InitializationViewController: UIViewController {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private let backgroundView = TadakMainBackgroundView()
    private let welcomingView = WelcomingView()
    
    private lazy var loadingView: AnimationView = {
        let configuration = LottieConfiguration(renderingEngine: .coreAnimation)
        let animationView = AnimationView(name: "loader", configuration: configuration)
        animationView.loopMode = .repeat(.greatestFiniteMagnitude)
        return animationView
    }()
    
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
        loadingView.play()
    }
    
    private func layout() {
        let stackView = UIStackView(arrangedSubviews: [loadingView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        
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
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(welcomingView.snp.bottom)
            $0.left.greaterThanOrEqualToSuperview()
            $0.right.lessThanOrEqualToSuperview()
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        loadingView.snp.makeConstraints {
            $0.width.height.equalTo(120)
        }
    }
}

// MARK: - Bind
extension InitializationViewController: View {
    func bind(reactor: InitializationViewReactor) {
        
        // MARK: State
        reactor.state.map(\.user)
            .bind(to: welcomingView.rx.user)
            .disposed(by: disposeBag)
    }
}

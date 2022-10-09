//
//  CompositionDetailViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit
import ReactorKit

final class CompositionDetailViewController: BottomSheetViewController {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private let dashboard = CompositionDetailDashboardView()
    
    private let holderImageView: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 42,
                                                        weight: .semibold)
        let image = UIImage(systemName: "chevron.compact.down",
                            withConfiguration: configuration)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white.withAlphaComponent(0.1)
        return imageView
    }()

    private let startButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "start_small")
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansKR(ofSize: 18, weight: .black)
        label.textColor = .white
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansKR(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let contentsTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textContainerInset = .init(top: 0, left: -4, bottom: 0, right: -4)
        textView.indicatorStyle = .white
        textView.isEditable = false
        return textView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, artistLabel])
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: Lifecycle
    init() {
        let height = UIScreen.main.bounds.height - UIWindow.safeAreaTopInset - 121
        super.init(containerHeight: height,
                   dismissibleHeight: height * 0.8,
                   maxDimmedAlpha: 0.4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
    }
    
    // MARK: Actions
    @objc
    private func singleTapGestureHandler() {
        self.dismiss(animated: true)
    }
    
    // MARK: Helpers
    private func configure() {
        holderView.backgroundColor = .customDarkNavy
        containerView.backgroundColor = .customNavy
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTapGestureHandler))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    private func layout() {
        holderView.snp.makeConstraints {
            $0.height.equalTo(110)
        }
        
        holderView.addSubview(holderImageView)
        holderImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        holderView.addSubview(titleStackView)
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(38)
            $0.left.equalToSuperview().inset(40)
        }
        
        holderView.addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.centerY.equalTo(titleStackView)
            $0.right.equalToSuperview().inset(24)
            $0.width.height.equalTo(44)
        }
        
        containerView.addSubview(contentsTextView)
        contentsTextView.snp.makeConstraints {
            $0.top.equalTo(holderView.snp.bottom).offset(35)
            $0.left.right.equalToSuperview().inset(40)
        }
        
        containerView.addSubview(dashboard)
        dashboard.snp.makeConstraints {
            $0.top.equalTo(contentsTextView.snp.bottom).offset(10)
            $0.left.bottom.right.equalToSuperview()
        }
    }
    
    private func updateComposition(_ composition: any Composition) {
        titleLabel.text = composition.title
        artistLabel.text = composition.artist

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.alignment = .justified
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.paragraphSpacing = 4

        contentsTextView.attributedText = NSAttributedString(
            string: composition.contents,
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.notoSansKR(ofSize: 15, weight: .medium)!,
                .paragraphStyle: paragraphStyle
            ])

        let padding = UIWindow.safeAreaBottomInset * 0.55
        let height: CGFloat = (composition is TadakComposition) ? 75 + padding : 0
        
        dashboard.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}

// MARK: - Bind
extension CompositionDetailViewController: View {

    func bind(reactor: CompositionDetailViewReactor) {

        // MARK: Action
        startButton.rx.tap
            .map(CompositionDetailViewReactor.Action.startButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // MARK: State
        reactor.pulse(\.$composition)
            .subscribe(onNext: updateComposition)
            .disposed(by: disposeBag)

        reactor.pulse(\.$score)
            .compactMap { $0 }
            .bind(to: dashboard.rx.score)
            .disposed(by: disposeBag)
    }
}

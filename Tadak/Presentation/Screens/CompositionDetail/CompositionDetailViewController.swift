//
//  CompositionDetailViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit
import ReactorKit

final class CompositionDetailViewController: UIViewController {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private let listButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "list"), for: .normal)
        button.contentMode = .center
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansKR(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansKR(ofSize: 18, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let startButton: TextButton = {
        let button = TextButton(colorType: .coral)
        button.title = "시작하기"
        button.titleFont = .notoSansKR(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let contentsTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.indicatorStyle = .white
        textView.isEditable = false
        return textView
    }()
    
    private lazy var keyboardDock: KeyboardDock = {
        let accessoryView = KeyboardDock(
            root: startButton,
            parent: self.view
        )
        return accessoryView
    }()
    
    private let dashboard = CompositionDetailDashboardView()
    
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
        dashboard.record = 0
    }
    
    private func layout() {
        // execute lazy var property
        _ = keyboardDock
        
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, artistLabel])
        titleStackView.axis = .vertical
        titleStackView.spacing = 1
        titleStackView.distribution = .fillProportionally
        titleStackView.alignment = .leading
        
        view.addSubview(listButton)
        listButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(26)
            $0.right.equalToSuperview().inset(26)
            $0.width.height.equalTo(44)
        }
        
        view.addSubview(titleStackView)
        titleStackView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(28)
            $0.centerY.equalTo(listButton)
        }
        
        view.addSubview(dashboard)
        dashboard.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(28)
        }
        
        view.addSubview(contentsTextView)
        contentsTextView.snp.makeConstraints {
            $0.top.equalTo(dashboard.snp.bottom).offset(30)
            $0.left.right.equalTo(dashboard)
            $0.bottom.equalTo(keyboardDock.snp.top).offset(-10)
        }
    }
    
    private func updateTypingDetail(_ typingDetail: TypingDetail) {
        titleLabel.text = typingDetail.composition.title
        artistLabel.text = typingDetail.composition.artist
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        contentsTextView.attributedText = NSAttributedString(
            string: typingDetail.composition.contents,
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.notoSansKR(ofSize: 16, weight: .medium)!,
                .paragraphStyle: paragraphStyle
            ])
        
        dashboard.typingMode = typingDetail.typingMode
    }
}

// MARK: - Bind
extension CompositionDetailViewController: View {
    
    func bind(reactor: CompositionDetailViewReactor) {
        
        // MARK: Action
        listButton.rx.tap
            .map(CompositionDetailViewReactor.Action.listButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .map(CompositionDetailViewReactor.Action.startButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.state.map(\.typingDetail)
            .subscribe(onNext: { [weak self] detail in
                self?.updateTypingDetail(detail)
            })
            .disposed(by: disposeBag)
    }
}

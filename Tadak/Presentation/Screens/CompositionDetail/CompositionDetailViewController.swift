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
    
    private let navigationView = ListButtonTypeNavigationView()
    private let dashboard = CompositionDetailDashboardView()
    private lazy var keyboardDock = KeyboardDock(root: startButton, parent: self.view)
    
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
        
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        
        view.addSubview(dashboard)
        dashboard.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(25)
            $0.left.right.equalToSuperview().inset(22)
        }
        
        view.addSubview(contentsTextView)
        contentsTextView.snp.makeConstraints {
            $0.top.equalTo(dashboard.snp.bottom).offset(30)
            $0.left.right.equalTo(dashboard)
            $0.bottom.equalTo(keyboardDock.snp.top).offset(-10)
        }
    }
    
    private func updateTypingDetail(_ typingDetail: TypingDetail) {
        navigationView.title = typingDetail.composition.title
        navigationView.subtitle = typingDetail.composition.artist
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.alignment = .left
        
        contentsTextView.attributedText = NSAttributedString(
            string: typingDetail.composition.contents,
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.notoSansKR(ofSize: 17, weight: .medium)!,
                .paragraphStyle: paragraphStyle
            ])
        
        dashboard.typingMode = typingDetail.typingMode
    }
}

// MARK: - Bind
extension CompositionDetailViewController: View {
    
    func bind(reactor: CompositionDetailViewReactor) {
        
        // MARK: Action
        navigationView.rx.listButtonTapped
            .map(CompositionDetailViewReactor.Action.listButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .map(CompositionDetailViewReactor.Action.startButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.state.map(\.typingDetail)
            .subscribe(onNext: updateTypingDetail)
            .disposed(by: disposeBag)
    }
}

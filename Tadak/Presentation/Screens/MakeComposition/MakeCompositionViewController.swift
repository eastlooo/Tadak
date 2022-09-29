//
//  MakeCompositionViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/24.
//

import UIKit
import SnapKit
import ReactorKit
import RxKeyboard

final class MakeCompositionViewController: UIViewController {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private let navigationView = ListButtonTypeNavigationView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private lazy var keyboardDock = KeyboardDock(root: saveButton, parent: self.view)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.text = "작가"
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.text = "내용"
        label.textColor = .white
        label.font = .notoSansKR(ofSize: 18, weight: .bold)
        return label
    }()

    private let saveButton: TextButton = {
        let button = TextButton(colorType: .coral)
        button.title = "저장하기"
        button.titleFont = .notoSansKR(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let titleTextField: TadakTextField = {
        let textField = TadakTextField(appearance: .light)
        textField.font = .notoSansKR(ofSize: 16, weight: .bold)
        textField.isPasteEnabled = true
        return textField
    }()
    
    private let artistTextField: TadakTextField = {
        let textField = TadakTextField(appearance: .light)
        textField.font = .notoSansKR(ofSize: 16, weight: .bold)
        textField.isPasteEnabled = true
        return textField
    }()
    
    private let contentsTextView: UITextView = {
        let textView = UITextView()
        textView.tintColor = .customDarkNavy
        textView.backgroundColor = .white
        textView.isScrollEnabled = false
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.lineSpacing = 3
        
        textView.typingAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.notoSansKR(ofSize: 16, weight: .bold)!,
            .paragraphStyle: paragraphStyle
        ]
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
        
        navigationView.title = "글 추가"
    }
    
    private func layout() {
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(10)
            $0.left.right.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.left.equalToSuperview().inset(24)
        }
        
        titleTextField.layer.cornerRadius = 10
        titleTextField.layer.cornerCurve = .continuous
        contentView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(18)
            $0.height.equalTo(45)
        }
        
        contentView.addSubview(artistLabel)
        artistLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(24)
        }
        
        artistTextField.layer.cornerRadius = 10
        artistTextField.layer.cornerCurve = .continuous
        contentView.addSubview(artistTextField)
        artistTextField.snp.makeConstraints {
            $0.top.equalTo(artistLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(18)
            $0.height.equalTo(45)
        }
        
        contentView.addSubview(contentsLabel)
        contentsLabel.snp.makeConstraints {
            $0.top.equalTo(artistTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(24)
        }
        
        contentsTextView.layer.cornerRadius = 10
        contentsTextView.layer.cornerCurve = .continuous
        contentView.addSubview(contentsTextView)
        contentsTextView.snp.makeConstraints {
            $0.top.equalTo(contentsLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(18)
            $0.height.greaterThanOrEqualTo(200)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        _ = keyboardDock
    }
}

extension MakeCompositionViewController: View {
    
    func bind(reactor: MakeCompositionViewReactor) {
        
        // MARK: Action
        navigationView.rx.listButtonTapped
            .map(MakeCompositionViewReactor.Action.listButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .map(MakeCompositionViewReactor.Action.saveButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        titleTextField.rx.text.orEmpty
            .map(MakeCompositionViewReactor.Action.titleText)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        artistTextField.rx.text.orEmpty
            .map(MakeCompositionViewReactor.Action.artistText)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        contentsTextView.rx.text.orEmpty
            .map(MakeCompositionViewReactor.Action.contentsText)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.pulse(\.$isValidate)
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // MARK: View
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(keyboardDock.rx.keyboardHeight)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.isHidden
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let inset = self.keyboardDock.frame.height
                self.scrollView.contentInset.bottom = inset
            })
            .disposed(by: disposeBag)
    }
}

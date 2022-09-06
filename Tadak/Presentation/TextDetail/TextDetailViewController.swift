//
//  TextDetailViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit

final class TextDetailViewController: UIViewController {
    
    // MARK: Properties
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
        button.titleFont = .notoSansKR(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let contentsTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textContainer.lineFragmentPadding = -10
        textView.textContainerInset = .zero
        textView.indicatorStyle = .white
        return textView
    }()
    
    private let dashboard = TextDetailDashboardView()
    
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
        
        titleLabel.text = "별 헤는 밤"
        artistLabel.text = "윤동주"
        startButton.title = "시작하기"
        
        let contents = """
            계절이 지나가는 하늘에는
            가을로 가득 차 있습니다.

            나는 아무 걱정도 없이
            가을 속의 별들을 다 헬 듯합니다.

            가슴 속에 하나 둘 새겨지는 별을
            이제 다 못 헤는 것은
            쉬이 아침이 오는 까닭이요
            내일 밤이 남은 까닭이요
            아직 나의 청춘이 다 하지 않은 까닭입니다.
        """
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        contentsTextView.attributedText = NSAttributedString(
            string: contents,
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.notoSansKR(ofSize: 16, weight: .medium)!,
                .paragraphStyle: paragraphStyle
            ])
        
        dashboard.typingMode = .practice
        dashboard.record = 496
    }
    
    private func layout() {
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
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(30)
            $0.height.equalTo(55)
        }
        
        view.addSubview(contentsTextView)
        contentsTextView.snp.makeConstraints {
            $0.top.equalTo(dashboard.snp.bottom).offset(30)
            $0.left.right.equalTo(dashboard)
            $0.bottom.equalTo(startButton.snp.top).offset(-30)
        }
    }
}

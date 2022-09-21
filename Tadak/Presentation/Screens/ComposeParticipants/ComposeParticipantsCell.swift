//
//  ComposeParticipantsCell.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit
import ReactorKit

final class ComposeParticipantsCell: UITableViewCell {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private let nameTextField: TadakTextField = {
        let textField = TadakTextField()
        textField.font = .notoSansKR(ofSize: 18, weight: .medium)
        textField.textAlignment = .center
        textField.isSpaceEnabled = false
        return textField
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
    }
    
    // MARK: Helpers
    private func configure() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        let placeholder = "이름을 입력해주세요"
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .font: UIFont.notoSansKR(ofSize: 16, weight: .medium)!,
                .foregroundColor: UIColor.gray
            ]
        )
    }
    
    private func layout() {
        nameTextField.layer.cornerRadius = 22.5
        contentView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(7.5)
            $0.left.right.equalToSuperview().inset(15)
        }
    }
}

// MARK: Bind
extension ComposeParticipantsCell: View {
    
    func bind(reactor: ComposeParticipantsCellReactor) {
        
        // MARK: Action
        nameTextField.rx.controlEvent(.editingChanged)
            .asObservable()
            .withLatestFrom(nameTextField.rx.text.orEmpty)
            .map(ComposeParticipantsCellReactor.Action.changedText)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.pulse(\.$name)
            .take(1)
            .bind(to: nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$maxLength)
            .bind(to: nameTextField.rx.maxLength)
            .disposed(by: disposeBag)
    }
}

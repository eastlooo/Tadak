//
//  ComposeParticipantsCell.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit
import SnapKit

final class ComposeParticipantsCell: UITableViewCell {
    
    // MARK: Properties
    private let nameTextField: TadakTextField = {
        let textField = TadakTextField()
        textField.font = .notoSansKR(ofSize: 18, weight: .medium)
        textField.textAlignment = .center
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
    
    // MARK: Helpers
    private func configure() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        let placeholder = "이름을 입력해주세요 (2~6글자)"
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

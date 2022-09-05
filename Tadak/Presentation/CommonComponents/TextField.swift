//
//  TextField.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit

class TextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autocorrectionType = .no
        autocapitalizationType = .none
        spellCheckingType = .no
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

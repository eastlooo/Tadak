//
//  AlertAction.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/10.
//

import UIKit

final class AlertAction {
    
    enum Style { case `default`, cancel }
    
    var title: String
    var style: Style
    var handler: ((AlertAction) -> Void)?
    
    init(title: String, style: Style, handler: ((AlertAction) -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

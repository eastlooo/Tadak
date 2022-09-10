//
//  Rx+UIView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/10.
//

import UIKit
import RxSwift

extension Reactive where Base: UIView {
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)
        }
    }
}

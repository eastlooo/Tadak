//
//  Rx+Loader.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/10.
//

import RxSwift

extension Reactive where Base: Loader {
    static var show: Binder<Bool> {
        return Binder(Loader.shared) { _, show in
            if show {
                Loader.show()
            } else {
                Loader.dismiss()
            }
        }
    }
}

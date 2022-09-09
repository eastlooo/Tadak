//
//  UIWindow++.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/09.
//

import UIKit

extension UIWindow {
    static var keyWindow: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }
    }
}

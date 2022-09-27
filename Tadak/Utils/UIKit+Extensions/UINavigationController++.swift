//
//  UINavigationController++.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/27.
//

import UIKit

extension UINavigationController {
    
    func fadeToViewController(_ viewController: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        self.view.layer.add(transition, forKey: nil)
        self.pushViewController(viewController, animated: false)
    }
}

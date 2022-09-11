//
//  NavigationController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import UIKit

final class NavigationController: UINavigationController {
    
    // MARK: Properties
    override var childForStatusBarStyle: UIViewController? { topViewController }
    
    override var viewControllers: [UIViewController] {
        didSet { setNeedsStatusBarAppearanceUpdate() }
    }
    
    // MARK: Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Helpers
    private func configure() {
        setNavigationBarHidden(true, animated: false)
        interactivePopGestureRecognizer?.isEnabled = false
    }
}

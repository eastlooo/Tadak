//
//  SceneDelegate.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/04.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let viewContoller = TadakMainViewController()
        window?.rootViewController = viewContoller
        window?.makeKeyAndVisible()
    }
}

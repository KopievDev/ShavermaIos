//
//  SceneDelegate.swift
//  Shaverma
//
//  Created by Иван Копиев on 02.04.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let winScene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: winScene)
        window?.rootViewController = MainScreen(vcs: Category.categories.map(TableVC.init)).withStack(configurator: NavigationBarStyle.primary.configuration)
        window?.makeKeyAndVisible()
    }
}


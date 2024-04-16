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
        Task {
            do {
                let categoies = try await ShavermaAPI.shared.categories()
                let vc = ShavermaAPI.shared.token == nil
                    ? AuthScreen().withStack(configurator: NavigationBarStyle.primary.configuration)
                    : TabbarScreen(categories: categoies).build()
                window?.rootViewController = vc
                window?.makeKeyAndVisible()
            } catch {
                let vc = ShavermaAPI.shared.token == nil
                    ? AuthScreen().withStack(configurator: NavigationBarStyle.primary.configuration)
                    : TabbarScreen(categories: Category.categories).build()
                window?.rootViewController = vc
                window?.makeKeyAndVisible()
            }
        }
    }
}


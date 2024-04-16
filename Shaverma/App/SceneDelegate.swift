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
        guard !ShavermaAPI.shared.token.isEmpty else {
            window?.rootViewController = AuthScreen().withStack(configurator: NavigationBarStyle.primary.configuration)
            window?.makeKeyAndVisible()
            return
        }
        Task {
            do {
                let categoies = try await ShavermaAPI.shared.categories()
                window?.rootViewController = TabbarScreen(categories: categoies).build()
                window?.makeKeyAndVisible()
            } catch {
                window?.rootViewController = TabbarScreen(categories: Category.categories).build()
                window?.makeKeyAndVisible()
            }
        }
    }
}


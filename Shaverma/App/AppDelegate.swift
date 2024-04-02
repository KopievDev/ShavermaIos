//
//  AppDelegate.swift
//  Shaverma
//
//  Created by Иван Копиев on 02.04.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let api = ShavermaAPI()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Task {
            let categoies = try await api.categories()
            print(categoies)
        }
        return true
    }
}


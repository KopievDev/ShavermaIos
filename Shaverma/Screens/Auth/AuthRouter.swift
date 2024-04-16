//
//  AuthRouter.swift
//  VeLo Player
//
// Created by Иван Копиев on 04.04.2024.
//

import UIKit

final class AuthRouter: Router {
    weak var vc: AuthVC?

    func routeToMain(categories: [Category]) {
        Navigator.shared.makeRoot(screen: TabbarScreen(categories: categories))
    }
}

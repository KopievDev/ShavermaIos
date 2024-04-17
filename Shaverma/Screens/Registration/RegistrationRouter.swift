//
//  RegistrationRouter.swift
//  VeLo Player
//
// Created by Иван Копиев on 17.04.2024.
//

import UIKit

final class RegistrationRouter: Router {
    weak var vc: RegistrationVC?

    func routeToTabBar() {
    }
    
    func routeToMain(categories: [Category]) {
        Navigator.shared.makeRoot(screen: TabbarScreen(categories: categories))
    }
}

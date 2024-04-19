//
//  ProfileRouter.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import UIKit

final class ProfileRouter: Router {
    weak var vc: ProfileVC?

    func routeToShowAddress() {
        navigator.push(screen: AdressShowScreen())
    }

    func routeToShowMe() {
        navigator.push(screen: ProfileViewerScreen())
    }

    func routeToOrders() {
        navigator.push(screen: OrdersScreen())
    }

    func logout() {
        navigator.makeRoot(vc: AuthScreen().withStack(configurator: NavigationBarStyle.primary.configuration))
    }
}

//
//  ProfileRouter.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import UIKit

final class ProfileRouter: Router {
    weak var vc: ProfileVC?

    func routeToSomeScreen() {
        
    }

    func logout() {
        
        navigator.makeRoot(screen: AuthScreen())
    }
}

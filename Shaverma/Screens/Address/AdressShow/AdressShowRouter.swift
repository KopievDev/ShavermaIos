//
//  AdressShowRouter.swift
//  VeLo Player
//
// Created by Иван Копиев on 16.04.2024.
//

import UIKit

final class AdressShowRouter: Router {
    weak var vc: AdressShowVC?

    func routeToChangeAddress() {
        navigator.push(screen: AddressSelectScreen { _ in })
    }
}

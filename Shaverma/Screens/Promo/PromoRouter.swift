//
//  PromoRouter.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import UIKit

final class PromoRouter: Router {
    weak var vc: PromoVC?

    func routeToSomeScreen() {
        navigator.push(screen: AddressSelectScreen { [weak self] image in
            guard let self else { return }
            vc?.set(image: image)
        })
    }
}

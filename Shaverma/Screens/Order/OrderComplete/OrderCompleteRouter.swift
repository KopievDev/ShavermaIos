//
//  OrderCompleteRouter.swift
//  VeLo Player
//
// Created by Иван Копиев on 19.04.2024.
//

import UIKit

final class OrderCompleteRouter: Router {
    weak var vc: OrderCompleteVC?

    func routeToMenu() {
        navigator.chain { nav in
            nav.popToRoot() {
                nav.select(tab: 0)
            }
        }
    }
}

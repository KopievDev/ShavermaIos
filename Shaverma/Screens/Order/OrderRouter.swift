//
//  OrderRouter.swift
//  VeLo Player
//
// Created by Иван Копиев on 19.04.2024.
//

import UIKit

final class OrderRouter: Router {
    weak var vc: OrderVC?

    func routeToComplete(order: OrderResponse) {
        navigator.push(screen: OrderCompleteScreen(order: order))
    }

    func routeToChangeAddress() {
        navigator.push(screen: AddressSelectScreen { _ in })
    }
}

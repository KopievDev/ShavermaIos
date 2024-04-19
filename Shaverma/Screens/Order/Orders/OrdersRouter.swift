//
//  OrdersRouter.swift
//  VeLo Player
//
// Created by Иван Копиев on 19.04.2024.
//

import UIKit

final class OrdersRouter: Router {
    weak var vc: OrdersVC?

    func routeTo(order: OrderResponse) {
        navigator.push(screen: OrderViewerScreen(order: order))
    }
}

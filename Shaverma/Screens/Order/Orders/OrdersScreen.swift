//
//  OrdersScreen.swift
//  VeLo Player
//
// Created by Иван Копиев on 19.04.2024.
//

import UIKit

struct OrdersScreen: Screen {

    func build() -> OrdersVC {
        let viewModel = OrdersViewModel()
        let router = OrdersRouter()
        let vc = OrdersVC(viewModel: viewModel, router: router)
        vc.navigationItem.titleView = UILabel(
            text: "Заказы",
            font: .bold(16),
            textColor: .staticWhite,
            lines: 0,
            alignment: .left
        )
        return vc
    }
}

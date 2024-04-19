//
//  OrderScreen.swift
//  VeLo Player
//
// Created by Иван Копиев on 19.04.2024.
//

import UIKit

struct OrderScreen: Screen {

    func build() -> OrderVC {
        let viewModel = OrderViewModel()
        let router = OrderRouter()
        let vc = OrderVC(viewModel: viewModel, router: router)
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.titleView = UILabel(
            text: "Оформление заказа",
            font: .bold(16),
            textColor: .staticWhite,
            lines: 0,
            alignment: .left
        )
        return vc
    }
}

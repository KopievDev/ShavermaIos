//
//  CartScreen.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import UIKit

struct CartScreen: Screen {

    func build() -> CartVC {
        let viewModel = CartViewModel()
        let router = CartRouter()
        let vc = CartVC(viewModel: viewModel, router: router)
        vc.tabBarItem.image = .comission
        vc.title = "Корзина"
        vc.navigationItem.titleView = UILabel(
            text: "Корзина",
            font: .bold(16),
            textColor: .staticWhite,
            lines: 0,
            alignment: .left
        )
        return vc
    }
}

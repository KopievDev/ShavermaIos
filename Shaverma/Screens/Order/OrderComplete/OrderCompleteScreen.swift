//
//  OrderCompleteScreen.swift
//  VeLo Player
//
// Created by Иван Копиев on 19.04.2024.
//

import UIKit

struct OrderCompleteScreen: Screen {

    let order: OrderResponse

    func build() -> OrderCompleteVC {
        let viewModel = OrderCompleteViewModel(order: order)
        let router = OrderCompleteRouter()
        let vc = OrderCompleteVC(viewModel: viewModel, router: router)
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.titleView = UILabel(
            text: "Заказ оформлен",
            font: .bold(16),
            textColor: .staticWhite,
            lines: 0,
            alignment: .left
        )
        return vc
    }
}

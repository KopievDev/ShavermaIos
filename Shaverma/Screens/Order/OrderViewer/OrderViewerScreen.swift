//
//  OrderViewerScreen.swift
//  VeLo Player
//
// Created by Иван Копиев on 19.04.2024.
//

import UIKit

struct OrderViewerScreen: Screen {
    let order: OrderResponse

    func build() -> OrderViewerVC {
        let viewModel = OrderViewerViewModel(order: order)
        let router = OrderViewerRouter()
        let vc = OrderViewerVC(viewModel: viewModel, router: router)
        return vc
    }
}

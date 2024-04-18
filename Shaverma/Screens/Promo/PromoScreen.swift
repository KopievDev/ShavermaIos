//
//  PromoScreen.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import UIKit

struct PromoScreen: Screen {

    func build() -> PromoVC {
        let viewModel = PromoViewModel()
        let router = PromoRouter()
        let vc = PromoVC(viewModel: viewModel, router: router)
        vc.tabBarItem.image = .promo
        vc.title = "Акции"
        vc.navigationItem.titleView = UILabel(
            text: "Акции",
            font: .bold(16),
            textColor: .staticWhite,
            lines: 0,
            alignment: .left
        )
        return vc
    }
}

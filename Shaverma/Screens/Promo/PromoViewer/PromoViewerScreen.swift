//
//  PromoViewerScreen.swift
//  VeLo Player
//
// Created by Иван Копиев on 17.04.2024.
//

import UIKit

struct PromoViewerScreen: Screen {

    let promo: PromoResponse

    func build() -> PromoViewerVC {
        let viewModel = PromoViewerViewModel(promo: promo)
        let router = PromoViewerRouter()
        let vc = PromoViewerVC(viewModel: viewModel, router: router)
        vc.navigationItem.titleView = UILabel(
            text: "Акция",
            font: .bold(16),
            textColor: .staticWhite,
            lines: 0,
            alignment: .center
        )
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
}

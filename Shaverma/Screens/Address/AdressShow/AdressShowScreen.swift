//
//  AdressShowScreen.swift
//  VeLo Player
//
// Created by Иван Копиев on 16.04.2024.
//

import UIKit

struct AdressShowScreen: Screen {

    func build() -> AdressShowVC {
        let viewModel = AdressShowViewModel()
        let router = AdressShowRouter()
        let vc = AdressShowVC(viewModel: viewModel, router: router)
        vc.navigationItem.titleView = UILabel(
            text: "Текущий адрес",
            font: .bold(16),
            textColor: .staticWhite,
            lines: 0,
            alignment: .left
        )
        return vc
    }
}

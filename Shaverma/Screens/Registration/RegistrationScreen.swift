//
//  RegistrationScreen.swift
//  VeLo Player
//
// Created by Иван Копиев on 17.04.2024.
//

import UIKit

struct RegistrationScreen: Screen {

    func build() -> RegistrationVC {
        let viewModel = RegistrationViewModel()
        let router = RegistrationRouter()
        let vc = RegistrationVC(viewModel: viewModel, router: router)
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.titleView = UILabel(
            text: "Регистрация",
            font: .bold(16),
            textColor: .staticWhite,
            lines: 0,
            alignment: .left
        )
        return vc
    }
}

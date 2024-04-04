//
//  AuthScreen.swift
//  VeLo Player
//
// Created by Иван Копиев on 04.04.2024.
//

import UIKit

struct AuthScreen: Screen {

    func build() -> AuthVC {
        let viewModel = AuthViewModel()
        let router = AuthRouter()
        let vc = AuthVC(viewModel: viewModel, router: router)
        vc.navigationItem.titleView = UILabel(
            text: "Авторизация",
            font: .bold(16),
            textColor: .staticWhite,
            lines: 0,
            alignment: .left
        )
        return vc
    }
}

//
//  ProfileScreen.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import UIKit

struct ProfileScreen: Screen {

    func build() -> ProfileVC {
        let viewModel = ProfileViewModel()
        let router = ProfileRouter()
        let vc = ProfileVC(viewModel: viewModel, router: router)
        vc.tabBarItem.image = .user
        vc.title = "Профиль"
        vc.navigationItem.titleView = UILabel(
            text: "Профиль",
            font: .bold(16),
            textColor: .staticWhite,
            lines: 0,
            alignment: .left
        )
        return vc
    }
}

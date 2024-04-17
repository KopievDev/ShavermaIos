//
//  ProfileViewerScreen.swift
//  VeLo Player
//
// Created by Иван Копиев on 17.04.2024.
//

import UIKit

struct ProfileViewerScreen: Screen {

    func build() -> ProfileViewerVC {
        let viewModel = ProfileViewerViewModel()
        let router = ProfileViewerRouter()
        let vc = ProfileViewerVC(viewModel: viewModel, router: router)
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

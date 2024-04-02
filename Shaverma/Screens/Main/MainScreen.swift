//
//  MainScreen.swift
//  VeLo Player
//
// Created by Иван Копиев on 02.04.2024.
//

import UIKit

struct MainScreen: Screen {

    let vcs: [WithTable]

    func build() -> MainVC {
        let viewModel = MainViewModel(vcs: vcs)
        let router = MainRouter()
        let vc = MainVC(viewModel: viewModel, router: router)
        vc.tabBarItem.image = .doc

//        vc.hidesBottomBarWhenPushed = true
        return vc
    }
}

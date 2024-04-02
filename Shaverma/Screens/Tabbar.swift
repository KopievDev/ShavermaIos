//
//  Tabbar.swift
//  Shaverma
//
//  Created by Иван Копиев on 02.04.2024.
//

import UIKit

class Tabbar: UITabBarController {

    init(vcs: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        viewControllers = vcs
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError(.notImplememt)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.layer.shadowColor = UIColor.staticWhite.cgColor
        tabBar.layer.shadowOpacity = 0.2
        tabBar.layer.shadowRadius = 10
        tabBar.layer.shadowOffset = CGSize(width: 0.0, height: -3)
        tabBar.clipsToBounds = false
    }
}
private extension Tabbar {
    func setupUI() {
        tabBar.backgroundColor(.primaryBase)
        .corners(.top, radius: 16)
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .primaryBase
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.disabledButton]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.staticWhite]
        appearance.stackedLayoutAppearance.normal.iconColor = .disabledButton
        appearance.stackedLayoutAppearance.selected.iconColor = .orangeButton
        tabBar.standardAppearance = appearance
    }

    func bind() {

    }
}

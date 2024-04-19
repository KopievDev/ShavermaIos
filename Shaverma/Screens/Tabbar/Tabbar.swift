//
//  Tabbar.swift
//  Shaverma
//
//  Created by Иван Копиев on 02.04.2024.
//

import UIKit
import Combine

struct TabbarScreen: Screen {
    let categories: [Category]
    
    func build() -> some UIViewController {
        Tabbar(vcs: [
            MainScreen(vcs: categories.map(TableVC.init)).withStack(configurator: NavigationBarStyle.primary.configuration),
            PromoScreen().withStack(configurator: NavigationBarStyle.primary.configuration),
            ProfileScreen().withStack(configurator: NavigationBarStyle.primary.configuration),
            CartScreen().withStack(configurator: NavigationBarStyle.primary.configuration)
        ])
    }
}

final class Tabbar: UITabBarController {

    private var subscriptions: Set<AnyCancellable> = []

    init(vcs: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        viewControllers = vcs
        setupUI()
        CartStorage.shared.start()
        CartStorage.shared.$cartResponse
            .sink { [weak self] resp in guard let self else { return }
                if let count = resp?.products.count {
                    tabBar.items?[3].badgeValue = count == 0 ? nil : "\(count)"
                } else {
                    tabBar.items?[3].badgeValue = nil
                }

            }.store(in: &subscriptions)
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

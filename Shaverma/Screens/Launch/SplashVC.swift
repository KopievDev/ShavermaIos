//
//  SplashVC.swift
//  Shaverma
//
//  Created by Иван Копиев on 19.04.2024.
//

import UIKit
import Combine
import Lottie

final class SplashVC: UIViewController {

    private let loadingView: LottieAnimationView = {
        let view = LottieAnimationView(width: 240, height: 240)
        view.animation = LottieAnimation.named("splash")
        view.animationSpeed = 2
        view.alpha = 1
        view.loopMode = .loop
        view.contentMode = .scaleAspectFill
        view.play()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let appLabel = UILabel(
        text: "Шаурма на районе",
        font: .systemFont(ofSize: 17, weight: .semibold),
        textColor: .staticWhite,
        lines: 1,
        alignment: .center
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        Task {
            await delay(1.5)
            guard !ShavermaAPI.shared.token.isEmpty else {
                Navigator.shared.makeRoot(vc: AuthScreen().withStack(configurator: NavigationBarStyle.primary.configuration))
                return
            }
            do {
                let categoies = try await ShavermaAPI.shared.categories()
                Navigator.shared.makeRoot(vc: TabbarScreen(categories: categoies).build())
            } catch {
                Navigator.shared.makeRoot(vc: TabbarScreen(categories: Category.categories).build())
            }
        }
    }

    func delay(_ seconds: TimeInterval) async {
        try? await Task<Never, Never>.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}

private extension SplashVC {
    func setupUI() {
        view.backgroundColor(.primaryBase)
        [loadingView, appLabel].addOnParent(view: view)
        loadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        appLabel.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaInsets).inset(16)
            $0.bottom.equalTo(view.safeAreaInsets).inset(60)
        }
    }
}

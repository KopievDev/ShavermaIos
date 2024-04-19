//
//  Navigator.swift
//  Shaverma
//
//  Created by Иван Копиев on 02.04.2024.
//

import UIKit

typealias IndexBlock = (Int) -> Void
typealias StringBlock = (String) -> Void
typealias BoolBlock = (Bool) -> Void
typealias VoidBlock = () -> Void

protocol Screen {
    associatedtype VC: UIViewController
    func build() -> VC
}

extension Screen {
    func withStack(configurator: NavigationBarConfiguration) -> NavigationController {
        NavigationController(rootViewController: build(), configuration: configurator)
    }
}

class Router {
    let navigator: Navigator = .shared
}

final class Navigator {

    static let shared = Navigator()

    var window: UIWindow? {
        UIApplication.shared.windows.first
    }

    var topVc: UIViewController? {
        UIApplication.topViewController()
    }

    var tabbar: UITabBarController? {
        UIApplication.shared.windows.first?.rootViewController as? UITabBarController
    }

    func makeRoot(
        screen: any Screen,
        completion: BoolBlock? = nil
    ) {
        guard let window else { return }
        window.rootViewController = screen.build()
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(
            with: window,
            duration: duration,
            options: options,
            animations: {},
            completion: completion
        )
    }

    func push(
        screen: any Screen,
        animated: Bool = true,
        completion: VoidBlock? = nil
    ) {
        guard let topVc else { return }
        let vc = screen.build()
        if let nav = topVc.navigationController {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            nav.pushViewController(vc, animated: animated)
            CATransaction.commit()
        } else {
            topVc.present(UINavigationController(rootViewController: vc), animated: animated)
        }
    }

    func popToRoot(
        animated: Bool = true,
        completion: VoidBlock? = nil
    ) {
        guard let topVc, let nav = topVc.navigationController else { return }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        nav.popToRootViewController(animated: animated)
        CATransaction.commit()
    }

    func present(
        screen: any Screen,
        modalPresentationStyle: UIModalPresentationStyle = .formSheet,
        animated: Bool = true,
        completion: VoidBlock? = nil
    ) {
        guard let topVc else { return }
        let vc = screen.build()
        vc.modalPresentationStyle = modalPresentationStyle
        topVc.present(vc, animated: animated, completion: completion)
    }

    func select(tab index: Int) {
        guard let tabbar, index < tabbar.viewControllers?.count ?? 0 else { return }
        tabbar.selectedIndex = index
    }

    func chain(navigator: (Navigator) -> Void) {
        navigator(self)
    }
}

private extension UIApplication {

    class func topViewController() -> UIViewController? {

        if var vc = UIApplication.shared.windows.first?.rootViewController {
            if vc is UITabBarController { vc = (vc as! UITabBarController).selectedViewController! }
            if vc is UINavigationController { vc = (vc as! UINavigationController).topViewController! }
            while (vc.presentedViewController) != nil &&
                (String(describing: type(of: vc.presentedViewController!)) != "SFSafariViewController") &&
                (String(describing: type(of: vc.presentedViewController!)) != "UIAlertController") {
                    vc = vc.presentedViewController!
                    if vc is UINavigationController { vc = (vc as! UINavigationController).topViewController! }
            }
            return vc
        } else {
            return nil
        }
    }
}

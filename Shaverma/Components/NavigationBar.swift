//
//  NavigationBar.swift
//  Shaverma
//
//  Created by Иван Копиев on 02.04.2024.
//

import UIKit

@objc public protocol NavigationBarConfigurable {
    dynamic var navigationBarConfiguration: NavigationBarConfiguration { get }
}

@objc public protocol NavigationBarConfiguration {
    func apply(
        to viewController: UIViewController,
        transitioning from: UIViewController?,
        animated: Bool
    )

    ///Создание кнопки назад для конфигурации навбара
    func backButton() -> UIBarButtonItem?
}


public enum NavigationBarStyle {
    ///Основной
    case primary
    ///Скрытый
    case hidden
    ///Кастом
    case custom(backgroundColor: UIColor, tintColor: UIColor, textColor: UIColor)
    ///Прозрачный
    case transparent(tintColor: UIColor)
    ///Стандартный
    case base

    public var configuration: NavigationBarConfiguration {
        switch self {
        case .primary:
            return OpaqueBar(
                backgroundColor: .primaryBase,
                tintColor: .staticWhite,
                textColor: .staticWhite)
        case .hidden:
            return HiddenBar()
        case .custom(let backgroundColor, let tintColor, let textColor):
            return OpaqueBar(backgroundColor: backgroundColor, tintColor: tintColor, textColor: textColor)
        case .transparent(let tintColor):
            return TransparentBar(tintColor: tintColor)
        case .base:
            return StandartBar()
        }
    }
}

public class HiddenBar: NavigationBarConfiguration {

    public init() { }

    public func apply(to viewController: UIViewController, transitioning from: UIViewController?, animated: Bool) {
        viewController.navigationController?.setNavigationBarHidden(true, animated: animated)
        viewController.transitionCoordinator?.animate(alongsideTransition: nil) { context in
            guard !context.isCancelled else { return }
            viewController.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }

    public func backButton() -> UIBarButtonItem? {
        nil
    }
}

public class TransparentBar: NavigationBarConfiguration {

    private let tintColor: UIColor
    private let backImage = UIImage(systemName: "chevron-left")

    public init(tintColor: UIColor) {
        self.tintColor = tintColor
    }

    public func apply(to viewController: UIViewController, transitioning from: UIViewController?, animated: Bool) {
        UINavigationBar.appearance().layoutMargins.left = 16
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = nil
        appearance.backgroundColor = .clear
//        appearance.largeTitleTextAttributes = [.font: VeloFont.regular(28).font, .foregroundColor: UIColor.primaryText]
//        appearance.titleTextAttributes = [.font: VeloFont.regular(28).font, .foregroundColor: UIColor.primaryText]
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        viewController.navigationItem.standardAppearance = appearance
        viewController.navigationItem.scrollEdgeAppearance = appearance
        viewController.navigationController?.navigationBar.tintColor = tintColor
        viewController.navigationController?.setNavigationBarHidden(false, animated: animated)
        viewController.navigationController?.navigationBar.isTranslucent = true
    }

    public func backButton() -> UIBarButtonItem? {
        return UIBarButtonItem(image: backImage, style: .plain, target: nil, action: nil)
    }
}

public class OpaqueBar: NavigationBarConfiguration {

    private let backgroundColor: UIColor
    private let tintColor: UIColor
    private let textColor: UIColor
    private let backImage = UIImage(systemName: "chevron-left")

    public init(backgroundColor: UIColor, tintColor: UIColor, textColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.textColor = textColor
    }

    public func apply(to viewController: UIViewController, transitioning from: UIViewController?, animated: Bool) {
        UINavigationBar.appearance().layoutMargins.left = 16
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = nil
        appearance.backgroundColor = backgroundColor
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        appearance.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 28, weight: .bold), .foregroundColor: textColor]
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: textColor]
        viewController.navigationItem.standardAppearance = appearance
        viewController.navigationItem.scrollEdgeAppearance = appearance
        viewController.navigationController?.navigationBar.tintColor = tintColor
        viewController.navigationController?.setNavigationBarHidden(false, animated: animated)
        viewController.navigationController?.navigationBar.isTranslucent = false
    }

    public func backButton() -> UIBarButtonItem? {
        return UIBarButtonItem(image: backImage, style: .plain, target: nil, action: nil)
    }
}

public class StandartBar: NavigationBarConfiguration {
    private let backImage = UIImage(systemName: "chevron-left")

    public func apply(to viewController: UIViewController, transitioning from: UIViewController?, animated: Bool) {
//        viewController.navigationController?.navigationBar.tintColor = .button
    }

    public func backButton() -> UIBarButtonItem? {
        return UIBarButtonItem(image: backImage, style: .plain, target: nil, action: nil)
    }
}


public final class NavigationController: UINavigationController {

    private var _delegate: NavigationControllerDelegate?

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        topViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }

    public init(configuration: NavigationBarConfiguration) {
        _delegate = NavigationControllerDelegate(configuration: configuration)
        super.init(navigationBarClass: nil, toolbarClass: nil)
    }

    public init(
        rootViewController: UIViewController,
        configuration: NavigationBarConfiguration
    ) {
        _delegate = NavigationControllerDelegate(configuration: configuration)
        super.init(rootViewController: rootViewController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        delegate = _delegate
        interactivePopGestureRecognizer?.delegate = self
        view.backgroundColor = .clear
    }
}

extension NavigationController: UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1 &&
        !navigationBar.isHidden &&
        topViewController?.navigationItem.hidesBackButton == false
    }
}

final class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {

    private let defaultConfiguration: NavigationBarConfiguration
    private var observation: NSKeyValueObservation?

    init(configuration: NavigationBarConfiguration) {
        defaultConfiguration = configuration
    }

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController, animated: Bool
    ) {
        // hide back button title
        navigationController.viewControllers.dropLast().last?
            .navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        observeConfiguration(viewController)
        let from = viewController.transitionCoordinator?.viewController(forKey: .from)
        configuration(for: viewController)
            .apply(to: viewController, transitioning: from, animated: animated)
        viewController.transitionCoordinator?.animate(alongsideTransition: nil) { context in
            if let from = from, context.isCancelled {
                self.observeConfiguration(from)
                self.configuration(for: from)
                    .apply(to: from, transitioning: nil, animated: false)
            }
        }
    }

    private func configuration(for viewController: UIViewController) -> NavigationBarConfiguration {
        return (viewController as? NavigationBarConfigurable)?
            .navigationBarConfiguration ?? defaultConfiguration
    }

    private func observeConfiguration(_ viewController: UIViewController) {
        observation?.invalidate()
        guard let viewController = viewController as? (NavigationBarConfigurable & UIViewController) else { return }
        observation = observeConfiguration(viewController)
    }

    private func observeConfiguration<T: NavigationBarConfigurable & UIViewController>(_ object: T) -> NSKeyValueObservation {
        return object.observe(\.navigationBarConfiguration, options: .new) { [weak object] _, change in
            guard let viewController = object, let newValue = change.newValue else { return }
            newValue.apply(to: viewController, transitioning: nil, animated: true)
        }
    }
}

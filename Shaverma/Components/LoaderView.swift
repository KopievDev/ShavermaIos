//
//  LoaderView.swift
//  Shaverma
//
//  Created by Иван Копиев on 16.04.2024.
//

import UIKit

class LoaderView: Component {

    private let spin = SpinnerView()
        .color(.systemPurple)
        .size(width: 36, height: 36)
        .alpha(1)

    private let blurView = BlurView(
        radius: 5,
        color: .primaryBase
    )

    public override func commonInit() {
        tag = 999
        setupUI()
        spin.startAnimation()
    }

    override func setupUI() {
        [blurView, spin].addOnParent(view: self)
        spin.snp.makeConstraints { $0.center.equalToSuperview() }
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

extension UIViewController {
    func showLoader() {
        guard !view.subviews.contains(where: { $0.tag == 999 }) else { return }
        let loader = LoaderView().alpha(0)
        view.addSubview(loader)
        loader.snp.makeConstraints { $0.edges.equalToSuperview() }
        UIView.animate(withDuration: 0.15) { loader.alpha = 1 }
    }

    func dismissLoader() {
        if let loader = view.viewWithTag(999)  {
            UIView.animate(withDuration: 0.15) {
                loader.alpha = 0
            } completion: { _ in
                loader.removeFromSuperview()
            }
        }
    }
}

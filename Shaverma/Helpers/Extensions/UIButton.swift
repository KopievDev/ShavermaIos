//
//  UIButton.swift
//  VeLo Player
//
//  Created by Иван Копиев on 12.03.2024.
//

import UIKit

extension UIButton {

    convenience init(
        text: String?,
        font: UIFont = .systemFont(ofSize: 13, weight: .regular),
        textColor: UIColor = .primary,
        backgroundColor: UIColor? = .clear
    ) {
        self.init()
        setTitle(text, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = font
        self.backgroundColor = backgroundColor
    }

    @discardableResult
    public func withAnimate(_ withAnimate: Bool = true) -> Self {
        if withAnimate {
            startAnimatingPressActions()
        } else {
            removeTarget(self, action: #selector(animateIn(view:)), for:  [.touchDown, .touchDragEnter])
            removeTarget(self, action: #selector(animateOut(view:)), for:  [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
        }
        return self
    }

    @discardableResult
    public func withShadow(_ withShadow: Bool = true) -> Self {
        if withShadow {
            startAnimatingPressActions(withShadow)
        } else {
            removeTarget(self, action: #selector(animateInShadow(view:)), for:  [.touchDown, .touchDragEnter])
            removeTarget(self, action: #selector(animateOutShadow(view:)), for:  [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
        }
        return self
    }

    @objc
    open func animateIn(view: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            view.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }
    }

    @objc
    open func animateOut(view viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn) {
            viewToAnimate.transform = .identity
        }
    }

    @objc
    public func animateInShadow(view: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            view.layer.shadowRadius = 2
        }
    }

    @objc
    public func animateOutShadow(view viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn) {
            viewToAnimate.layer.shadowRadius = 4
        }
    }

    public func startAnimatingPressActions(_ withShadow: Bool = false) {
        let pressIn = withShadow ? #selector(animateInShadow(view:)) : #selector(animateIn(view:))
        let pressOut = withShadow ? #selector(animateOutShadow(view:)) : #selector(animateOut(view:))

        addTarget(self, action: pressIn, for: [.touchDown, .touchDragEnter])
        addTarget(self, action: pressOut, for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
}

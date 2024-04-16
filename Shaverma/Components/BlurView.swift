//
//  BlurView.swift
//  Shaverma
//
//  Created by Иван Копиев on 16.04.2024.
//

import UIKit

public class BlurView: UIView {

    private enum Constants {
        static let blurRadiusKey = "blurRadius"
        static let colorTintKey = "colorTint"
        static let colorTintAlphaKey = "colorTintAlpha"
    }

    // MARK: - Public
    var blurRadius: CGFloat = 10.0 {
        didSet { _setValue(blurRadius, forKey: Constants.blurRadiusKey) }
    }

    var colorTint: UIColor? {
        didSet { _setValue(colorTint, forKey: Constants.colorTintKey) }
    }

    var colorTintAlpha: CGFloat = 0.2 {
        didSet { _setValue(colorTintAlpha, forKey: Constants.colorTintAlphaKey) }
    }

    public var blurLayer: CALayer { visualEffectView.layer }

    // MARK: - Initialization

    public init(radius: CGFloat = 10.0, color: UIColor? = nil, colorAlpha: CGFloat = 0.2) {
        blurRadius = radius
        super.init(frame: .zero)
        backgroundColor = .clear
        setupViews()
        defer {
            blurRadius = radius
            colorTint = color
            colorTintAlpha = colorAlpha
        }
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        setupViews()
        defer {
            blurRadius = 10.0
            colorTint = nil
            colorTintAlpha = 0.2
        }
    }


    // MARK: - Private
    /// Visual effect view.
    private lazy var visualEffectView: UIVisualEffectView = {
        if #available(iOS 14.0, *) {
            return UIVisualEffectView(effect: customBlurEffect_ios14)
        } else {
            return UIVisualEffectView(effect: customBlurEffect)
        }
    }()

    /// Blur effect for IOS >= 14
    private lazy var customBlurEffect_ios14: CustomBlurEffect = {
        let effect = CustomBlurEffect.effect(with: .extraLight)
        effect.blurRadius = blurRadius
        return effect
    }()

    /// Blur effect for IOS < 14
    private lazy var customBlurEffect: UIBlurEffect = {
        return (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
    }()

    /// Sets the value for the key on the blurEffect.
    private func _setValue(_ value: Any?, forKey key: String) {
        if #available(iOS 14.0, *) {
            if key == Constants.blurRadiusKey {
                updateViews()
            }
            let subviewClass = NSClassFromString("_UIVisualEffectSubview") as? UIView.Type
            let visualEffectSubview: UIView? = visualEffectView.subviews.first { type(of: $0) == subviewClass }
            visualEffectSubview?.backgroundColor = colorTint
            visualEffectSubview?.alpha = colorTintAlpha
        } else {
            customBlurEffect.setValue(value, forKeyPath: key)
            visualEffectView.effect = customBlurEffect
        }
    }

    private func setupViews() {
        addSubview(visualEffectView)
        clipsToBounds = true
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    /// Update visualEffectView for ios14+, if we need to change blurRadius
    private func updateViews() {
        if #available(iOS 14.0, *) {
            visualEffectView.removeFromSuperview()
            let newEffect = CustomBlurEffect.effect(with: .extraLight)
            newEffect.blurRadius = blurRadius
            customBlurEffect_ios14 = newEffect
            visualEffectView = UIVisualEffectView(effect: customBlurEffect_ios14)
            setupViews()
        }
    }
}

class CustomBlurEffect: UIBlurEffect {

    public var blurRadius: CGFloat = 10.0

    private enum Constants {
        static let blurRadiusSettingKey = "blurRadius"
    }

    class func effect(with style: UIBlurEffect.Style) -> CustomBlurEffect {
        let result = super.init(style: style)
        object_setClass(result, self)
        return result as? CustomBlurEffect ?? CustomBlurEffect()
    }

    override func copy(with zone: NSZone? = nil) -> Any {
        let result = super.copy(with: zone)
        object_setClass(result, Self.self)
        return result
    }

    override var effectSettings: AnyObject {
        get {
            let settings = super.effectSettings
            settings.setValue(blurRadius, forKey: Constants.blurRadiusSettingKey)
            return settings
        }
        set {
            super.effectSettings = newValue
        }
    }

}

private var AssociatedObjectHandle: UInt8 = 0

extension UIVisualEffect {
    @objc var effectSettings: AnyObject {
        get { objc_getAssociatedObject(self, &AssociatedObjectHandle) as AnyObject }
        set { objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

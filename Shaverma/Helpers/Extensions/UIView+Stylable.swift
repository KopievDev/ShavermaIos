//
//  UIView+Stylable.swift
//  VeLo Player
//
//  Created by Иван Копиев on 04.03.2024.
//

import UIKit
import SnapKit

enum Corners: String, Codable {
    case top
    case bottom
    case full
    case none
    case leftTop
}

extension Stylable where Self: UIView {
    @discardableResult
    func cornerRadius(_ value: CGFloat) -> Self {
        self.layer.cornerRadius = value
        return self
    }

    @discardableResult
    func backgroundColor(_ value: UIColor) -> Self {
        self.backgroundColor = value
        return self
    }

    @discardableResult
    func clipsToBounds(_ value: Bool) -> Self {
        self.clipsToBounds = value
        return self
    }

    @discardableResult
    func isHidden(_ value: Bool) -> Self {
        self.isHidden = value
        return self
    }

    @discardableResult
    func hugging(_ priority: Float = 1000, for axis: NSLayoutConstraint.Axis = .vertical) -> Self {
        setContentHuggingPriority(UILayoutPriority(rawValue: priority), for: axis)
        return self
    }

    @discardableResult
    func resistance(_ priority: Float = 1000, for axis: NSLayoutConstraint.Axis = .vertical) -> Self {
        setContentCompressionResistancePriority(UILayoutPriority(rawValue: priority), for: axis)
        return self
    }

    @discardableResult
    func borderColor(_ color: UIColor) -> Self {
        layer.borderColor = color.cgColor
        return self
    }

    @discardableResult
    func borderWidth(_ width: CGFloat) -> Self {
        layer.borderWidth = width
        return self
    }

    @discardableResult
    func with(id: String) -> Self {
        accessibilityIdentifier = id
        return self
    }

    @discardableResult
    func with(tag: Int) -> Self {
        self.tag = tag
        return self
    }

    @discardableResult
    func addShadow(color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize) -> Self {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        return self
    }

    @discardableResult
    func size(width: CGFloat? = nil,
              height: CGFloat? = nil,
              minWidth: CGFloat? = nil,
              minHeight: CGFloat? = nil) -> Self {

        if let width {
            let constraint = widthAnchor.constraint(equalToConstant: width)
            constraint.priority = UILayoutPriority(999)
            constraint.isActive = true
        } else if let minWidth {
            let constraint = widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth)
            constraint.priority = UILayoutPriority(999)
            constraint.isActive = true
        }

        if let height {
            let constraint = heightAnchor.constraint(equalToConstant: height)
            constraint.priority = UILayoutPriority(999)
            constraint.isActive = true
        } else if let minHeight {
            let constraint = heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight)
            constraint.priority = UILayoutPriority(999)
            constraint.isActive = true
        }
        addConstraints(constraints)
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }

    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }

    @discardableResult
    func frame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }

    @discardableResult
    func withInteraction(_ enabled: Bool = true) -> Self {
        isUserInteractionEnabled = enabled
        return self
    }

    @discardableResult
    func corners(_ corners: Corners, radius: CGFloat = 16) -> Self {
        switch corners {
        case .top:
            cornerRadius(radius).layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .bottom:
            cornerRadius(radius).layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .full:
            cornerRadius(radius).layer.maskedCorners = [
                .layerMaxXMinYCorner,
                .layerMinXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner]
        case .none:
            cornerRadius(radius).layer.maskedCorners = []
        case .leftTop:
            cornerRadius(radius).layer.maskedCorners = [.layerMinXMinYCorner]
        }
        return self
    }
}

extension UIView {
    convenience init(width: CGFloat? = nil, height:  CGFloat? = nil) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        snp.makeConstraints {
            if let width { $0.width.equalTo(width) }
            if let height { $0.height.equalTo(height) }
        }
    }

    convenience init(embed: UIView, _ closure: (ConstraintMaker) -> Void) {
        self.init(frame: .zero)
        [embed].addOnParent(view: self)
        embed.snp.makeConstraints(closure)
    }
}

public extension Stylable where Self: UIImageView {
    @discardableResult
    func contentMode(_ contentMode: UIView.ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }

    @discardableResult
    func image(_ value: UIImage) -> Self {
        self.image = value
        return self
    }
}

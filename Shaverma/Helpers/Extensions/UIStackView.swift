//
//  UIStackView.swift
//  VeLo Player
//
//  Created by Иван Копиев on 07.03.2024.
//

import UIKit

extension UIStackView {

    func addArrangedSubview(views: [UIView]) {
        views.forEach(addArrangedSubview)
    }

    func removeArrangedAllSubview() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    func removeAll() {
        while let view = arrangedSubviews.first {
            removeArrangedSubview(view)
        }
        while let view = subviews.first {
            view.removeFromSuperview()
        }
    }

    func remove(at index: Int) {
        guard arrangedSubviews.count > index else { return }
        let view = arrangedSubviews[index]
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }

    convenience init(
        axis: NSLayoutConstraint.Axis,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat = 0,
        arrangedSubviews: [UIView]? = nil
    ) {
        self.init()
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
        if let arrangedSubviews = arrangedSubviews {
            self.addArrangedSubview(views: arrangedSubviews)
        }
    }

//    convenience init(
//        axis: NSLayoutConstraint.Axis,
//        alignment: UIStackView.Alignment = .fill,
//        distribution: UIStackView.Distribution = .fill,
//        spacing: CGFloat = 0,
//        subviews: @autoclosure () -> [UIView]
//    ) {
//        self.init()
//        self.axis = axis
//        self.alignment = alignment
//        self.distribution = distribution
//        self.spacing = spacing
//        self.addArrangedSubview(views: subviews())
//    }
}

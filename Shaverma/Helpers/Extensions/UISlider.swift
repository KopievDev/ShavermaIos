//
//  UISlider.swift
//  VeLo Player
//
//  Created by Иван Копиев on 11.03.2024.
//

import UIKit

extension UISlider {
    public func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        let percent = minimumValue + Float(location.x / bounds.width) * maximumValue
        setValue(percent, animated: true)
        sendActions(for: .valueChanged)
    }
}

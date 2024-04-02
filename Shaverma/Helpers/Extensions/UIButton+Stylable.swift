//
//  UIButton+Stylable.swift
//  VeLo Player
//
//  Created by Иван Копиев on 10.03.2024.
//

import UIKit

extension Stylable where Self: UIButton {
    @discardableResult
    func withImage(_ value: UIImage?, for state: UIControl.State = .normal) -> Self {
        setImage(value, for: state)
        return self
    }
}

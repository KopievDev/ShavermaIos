//
//  Collection+UIView.swift
//  VeLo Player
//
//  Created by Иван Копиев on 04.03.2024.
//

import UIKit

public extension Collection where Element: UIView {
    @discardableResult
    func addOnParent(view: UIView, withContraints: Bool = true) -> Self {
        forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = !withContraints
        }
        return self
    }
}

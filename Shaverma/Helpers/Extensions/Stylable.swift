//
//  Stylable.swift
//  VeLo Player
//
//  Created by Иван Копиев on 04.03.2024.
//

import UIKit

public protocol Stylable {}

extension UIView: Stylable {}
extension UICollectionViewLayout: Stylable {}

extension Stylable where Self: SpinnerView {
    @discardableResult
    func color(_ value: UIColor) -> Self {
        self.color = value
        return self
    }
}

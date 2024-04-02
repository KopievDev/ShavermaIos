//
//  UICollectionView+Stylable.swift
//  VeLo Player
//
//  Created by Иван Копиев on 04.03.2024.
//

import UIKit

public extension Stylable where Self: UICollectionView {

    @discardableResult
    func register<Cell: UICollectionViewCell>(_ type: Cell.Type) -> Self {
        register(type.self, forCellWithReuseIdentifier: type.reuseId)
        return self
    }


    @discardableResult
    func isScrollEnabled(_ isScrollEnabled: Bool) -> Self {
        self.isScrollEnabled = isScrollEnabled
        return self
    }
}

public extension Stylable where Self: UICollectionViewFlowLayout {

    @discardableResult
    func itemSize(_ itemSize: CGSize) -> Self {
        self.itemSize = itemSize
        return self
    }

    @discardableResult
    func minimumLineSpacing(_ minimumLineSpacing: CGFloat) -> Self {
        self.minimumLineSpacing = minimumLineSpacing
        return self
    }
}

extension UICollectionView {
    convenience init(layout: UICollectionViewLayout) {
        self.init(frame: .zero, collectionViewLayout: layout)
    }
}

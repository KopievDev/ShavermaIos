//
//  Sequence.swift
//  VeLo Player
//
//  Created by Иван Копиев on 10.03.2024.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

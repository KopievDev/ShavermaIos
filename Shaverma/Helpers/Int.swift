//
//  Int.swift
//  VeLo Player
//
//  Created by Иван Копиев on 03.03.2024.
//

import Foundation

extension Int {
    var msToSeconds: Double { Double(self) / 1000 }
    var remMsToSeconds: Double { Double(self) / 1000 * -1 }
}

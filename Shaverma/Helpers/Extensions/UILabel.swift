//
//  UILabel.swift
//  VeLo Player
//
//  Created by Ivan Kopiev on 03.03.2024.
//

import UIKit

extension UILabel {
    convenience init(
        text: String? = nil,
        font: UIFont = .systemFont(ofSize: 17),
        textColor: UIColor = .primaryBase,
        lines: Int = 1,
        alignment: NSTextAlignment = .center
    ) {
        self.init()
        self.text = text
        self.font = font
        self.numberOfLines = lines
        self.textAlignment = alignment
        self.textColor = textColor
    }
}

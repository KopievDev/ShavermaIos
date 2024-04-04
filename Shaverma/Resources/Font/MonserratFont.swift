//
//  MonserratFont.swift
//  Shaverma
//
//  Created by Иван Копиев on 04.04.2024.
//

import UIKit

enum MonserratFont {
    case regular(CGFloat)
    case bold(CGFloat)
    case italic(CGFloat)
    case boldItalic(CGFloat)
    case semiBold(CGFloat)


    var font: UIFont {
        switch self {
        case .regular(let size):
            FontFamily.MontserratAlternates.regular.font(size: size)
        case .bold(let size):
            FontFamily.MontserratAlternates.bold.font(size: size)
        case .italic(let size):
            FontFamily.MontserratAlternates.italic.font(size: size)
        case .boldItalic(let size):
            FontFamily.MontserratAlternates.boldItalic.font(size: size)
        case .semiBold(let size):
            FontFamily.MontserratAlternates.semiBold.font(size: size)
        }
    }
}

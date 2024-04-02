//
//  UIColor.swift
//  VeLo Player
//
//  Created by Иван Копиев on 12.03.2024.
//

import UIKit

@propertyWrapper
struct HexColor: Codable {

    var wrappedValue: UIColor

    init(wrappedValue: UIColor) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hexString = try container.decode(String.self)

        guard let color = UIColor(hex: hexString) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "The value is not a valid hex color"
            )
        }
        wrappedValue = color
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue.htmlRGBA)
    }
}

extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }

    convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }

    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        return (0, 0, 0, 0)
    }

    // hue, saturation, brightness and alpha components from UIColor**
    var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return (hue, saturation, brightness, alpha)
        }
        return (0,0,0,0)
    }

    var htmlRGB: String {
        let rgbaCache = rgba
        return String(
            format: "#%02x%02x%02x",
            Int(round(rgbaCache.red * 255)),
            Int(round(rgbaCache.green * 255)),
            Int(round(rgbaCache.blue * 255))
        )
    }

    var htmlRGBA: String {
        let rgbaCache = rgba
        return String(
            format: "#%02x%02x%02x%02x",
            Int(round(rgbaCache.red * 255)),
            Int(round(rgbaCache.green * 255)),
            Int(round(rgbaCache.blue * 255)),
            Int(round(rgbaCache.alpha * 255))
        )
    }
}

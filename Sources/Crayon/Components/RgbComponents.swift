//
//  RgbComponents.swift
//  Crayon
//
//  Created by David Walter on 20.03.22.
//

import Foundation

struct RgbComponents: Equatable {
    static var white: RgbComponents {
        RgbComponents(red: 1, green: 1, blue: 1, alpha: 1)
    }

    static var black: RgbComponents {
        RgbComponents(red: 0, green: 0, blue: 0, alpha: 1)
    }

    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double

    init(red: Double, green: Double, blue: Double, alpha: Double) {
        self.red = red.normalized()
        self.green = green.normalized()
        self.blue = blue.normalized()
        self.alpha = alpha.normalized()
    }

    private init(_ value: UInt, alpha: Double) {
        self.red = Double(value >> 16 & 0xFF) / 255
        self.green = Double(value >> 8 & 0xFF) / 255
        self.blue = Double(value & 0xFF) / 255
        self.alpha = alpha
    }

    init?(_ value: String) {
        var hex = value.hasPrefix("#") ? String(value.dropFirst()) : value
        var alpha = 1.0

        switch hex.count {
        case 3:
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        case 4:
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
            alpha = Double(UInt(hex.suffix(2), radix: 16) ?? 255) / 255
            hex = String(hex.dropLast(2))
        case 6:
            break
        case 8:
            alpha = Double(UInt(hex.suffix(2), radix: 16) ?? 255) / 255
            hex = String(hex.dropLast(2))
        default:
            return nil
        }

        guard let hexValue = UInt(hex, radix: 16) else { return nil }
        self.init(hexValue, alpha: alpha)
    }

    init(hsb: HsbComponents) {
        let c = hsb.brightness * hsb.saturation
        let h = hsb.hue * 360 / 60
        let x = c * (1 - abs(h.truncatingRemainder(dividingBy: 2) - 1))

        var (r, g, b) = (0.0, 0.0, 0.0)
        switch h {
        case 0 ..< 1:
            (r, g, b) = (c, x, 0)
        case 1 ..< 2:
            (r, g, b) = (x, c, 0)
        case 2 ..< 3:
            (r, g, b) = (0, c, x)
        case 3 ..< 4:
            (r, g, b) = (0, x, c)
        case 4 ..< 5:
            (r, g, b) = (x, 0, c)
        default: // 5..<6
            (r, g, b) = (c, 0, x)
        }

        let m = hsb.brightness - c
        self.init(red: r + m, green: g + m, blue: b + m, alpha: hsb.alpha)
    }
    
    init(alpha: Double) {
        self.red = Double.random(in: 0 ... 1)
        self.green = Double.random(in: 0 ... 1)
        self.blue = Double.random(in: 0 ... 1)
        self.alpha = alpha
    }

    func hex(prefix: String? = "#", withAlpha: Bool = false) -> String {
        [
            prefix,
            String(format: "%02X", Int(red * 255)),
            String(format: "%02X", Int(green * 255)),
            String(format: "%02X", Int(blue * 255)),
            withAlpha ? String(format: "%02X", Int(alpha * 255)) : nil
        ]
        .compactMap { $0 }
        .joined()
    }

    var lightness: Double {
        ((red * 299) + (green * 587) + (blue * 114)) / 1000
    }

    var isDark: Bool {
        lightness < 0.5
    }

    var isLight: Bool {
        !isDark
    }

    func contrast(to color: RgbComponents) -> Double {
        let l1 = lightness
        let l2 = color.lightness

        if l1 > l2 {
            return (l1 + 0.05) / (l2 + 0.05)
        } else {
            return (l2 + 0.05) / (l1 + 0.05)
        }
    }

    func contrast(to color: RgbComponents?) -> Double? {
        guard let color = color else {
            return nil
        }

        let value: Double = contrast(to: color)
        return value
    }

    func hasContrast(with color: RgbComponents) -> Bool {
        let contrast = contrast(to: color)
        return contrast > 7
    }

    func hasContrast(with color: RgbComponents?) -> Bool? {
        guard let color = color else { return nil }
        let value: Bool = hasContrast(with: color)
        return value
    }
    
    func negative(withAlpha: Bool) -> RgbComponents {
        RgbComponents(red: 1 - red, green: 1 - green, blue: 1 - blue, alpha: withAlpha ? 1 - alpha : alpha)
    }

    // MARK: - Equatable

    static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.red ~= rhs.red,
              lhs.green ~= rhs.green,
              lhs.blue ~= rhs.blue,
              lhs.alpha ~= rhs.alpha else { return false }
        return true
    }

    // MARK: - Blending

    func add(components: RgbComponents, withAlpha: Bool) -> RgbComponents {
        RgbComponents(red: red + components.red,
                      green: green + components.green,
                      blue: blue + components.blue,
                      alpha: withAlpha ? alpha + components.alpha : alpha)
    }
    
    func subtract(components: RgbComponents, withAlpha: Bool) -> RgbComponents {
        RgbComponents(red: red - components.red,
                      green: green - components.green,
                      blue: blue - components.blue,
                      alpha: withAlpha ? alpha - components.alpha : alpha)
    }
    
    func multiply(components: RgbComponents, withAlpha: Bool) -> RgbComponents {
        RgbComponents(red: red * components.red,
                      green: green * components.green,
                      blue: blue * components.blue,
                      alpha: withAlpha ? alpha * components.alpha : alpha)
    }
    
    func divide(components: RgbComponents, withAlpha: Bool) -> RgbComponents {
        RgbComponents(red: red / components.red,
                      green: green / components.green,
                      blue: blue / components.blue,
                      alpha: withAlpha ? alpha / components.alpha : alpha)
    }
    
    func mix(components: RgbComponents, weight: Double = 0.5, withAlpha: Bool) -> RgbComponents {
        let weight = weight.normalized()
        let red = (1 - weight) * red + weight * components.red
        let green = (1 - weight) * green + weight * components.green
        let blue = (1 - weight) * blue + weight * components.blue
        let alpha = (1 - weight) * alpha + weight * components.alpha
        return RgbComponents(red: red,
                             green: green,
                             blue: blue,
                             alpha: withAlpha ? alpha : self.alpha)
    }
}

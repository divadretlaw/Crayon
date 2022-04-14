//
//  CGColor.swift
//  Crayon
//
//  Created by David Walter on 20.03.22.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension CGColor {
    /// Checks if the color is dark
    ///
    /// - Returns: Wether the color is dark or not. Returns `nil` if determination wasn't possible
    public var isDark: Bool? {
        guard let lightness = rgbComponents?.lightness else { return nil }
        return lightness < 0.5
    }

    /// Calculates the contrast ratio to the given color
    ///
    /// - Parameter to: Color to check the contrast against
    /// - Returns: The contrast ratio. Returns `nil` if determination wasn't possible
    public func contrast(to color: CGColor) -> CGFloat? {
        guard let l1 = rgbComponents?.lightness,
              let l2 = color.rgbComponents?.lightness
        else {
            return nil
        }

        if l1 > l2 {
            return (l1 + 0.05) / (l2 + 0.05)
        } else {
            return (l2 + 0.05) / (l1 + 0.05)
        }
    }

    /// Checks if the contrast ratio is at least 7:1
    ///
    /// - Parameter with color: Color to check the contrast against
    /// - Returns: Wether the color contrast ratio is at least 7:1. Returns `nil` if determination wasn't possible
    public func hasContrast(with color: CGColor) -> Bool? {
        guard let contrast = contrast(to: color) else {
            return nil
        }

        return contrast > 7
    }

    /// Checks if the color is light
    ///
    /// - Returns: Wether the color is light or not. Returns `nil` if determination wasn't possible
    ///
    public var isLight: Bool? {
        guard let isDark = isDark else {
            return nil
        }
        return !isDark
    }

    /// Returns the hex value as String
    ///
    /// - Parameter prefix: The prefix of the hex value. Defaults to `#`
    /// - Parameter alpha: Wether to include the alpha channel in the hex String
    ///
    /// - Returns: The hex string or `nil` if the color couldn't be determined
    public func hex(prefix: String? = "#", withAlpha: Bool = false) -> String? {
        rgbComponents?.hex(prefix: prefix, withAlpha: withAlpha)
    }
}

// MARK: - Components

extension CGColor {
    var rgbComponents: RgbComponents? {
        RgbComponents(color: self)
    }

    var hsbComponents: HsbComponents? {
        HsbComponents(color: self)
    }
}

extension RgbComponents {
    init?(color: CGColor) {
        guard let components = RgbComponents(components: color.components) else {
            return nil
        }

        self = components
    }

    init?(components: [CGFloat]?) {
        guard let components = components else {
            return nil
        }

        switch components.count {
        case 1:
            red = components[0]
            green = components[0]
            blue = components[0]
            alpha = 1
        case 2:
            red = components[0]
            green = components[0]
            blue = components[0]
            alpha = components[1]
        case 3...:
            red = components[0]
            green = components[1]
            blue = components[2]

            if components.count > 3 {
                alpha = components[3]
            } else {
                alpha = 1
            }
        default:
            return nil
        }
    }
}

extension HsbComponents {
    init?(color: CGColor) {
        guard let components = RgbComponents(components: color.components) else {
            return nil
        }

        self = HsbComponents(rgb: components)
    }
}

@available(iOS 13, watchOS 6, tvOS 13, *)
extension CGColor {
    static func from(rgb components: RgbComponents) -> CGColor {
        CGColor(red: components.red,
                green: components.green,
                blue: components.blue,
                alpha: components.alpha)
    }
    
    static func from(hsb components: HsbComponents) -> CGColor {
        let rgbComponents = RgbComponents(hsb: components)
        return CGColor(red: rgbComponents.red,
                       green: rgbComponents.green,
                       blue: rgbComponents.blue,
                       alpha: rgbComponents.alpha)
    }
    
    var rgbComponentsOrBlack: RgbComponents {
        RgbComponents(color: self) ?? .black
    }

    var rgbComponentsOrWhite: RgbComponents {
        RgbComponents(color: self) ?? .white
    }

    var hsbComponentsOrBlack: HsbComponents {
        HsbComponents(color: self) ?? .black
    }
    
    var hsbComponentsOrWhite: HsbComponents {
        HsbComponents(color: self) ?? .white
    }

    /// Merge the colors via addition in RGB
    public static func + (lhs: CGColor, rhs: CGColor) -> CGColor {
        lhs.add(color: rhs)
    }

    /// Merge the colors via subtraction in RGB
    public static func - (lhs: CGColor, rhs: CGColor) -> CGColor {
        lhs.subtract(color: rhs)
    }

    /// Merge the colors via multiplication in RGB
    public static func * (lhs: CGColor, rhs: CGColor) -> CGColor {
        lhs.multiply(color: rhs)
    }

    /// Merge the colors via division in RGB
    public static func / (lhs: CGColor, rhs: CGColor) -> CGColor {
        lhs.divide(color: rhs)
    }

    /// Add another color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to add
    /// - Returns: The merged colors
    public func add(_ colorSpace: ColorSpace = .rgb, color: CGColor) -> CGColor {
        switch colorSpace {
        case .rgb:
            let components = rgbComponentsOrBlack.add(components: color.rgbComponentsOrBlack, withAlpha: false)
            return CGColor.from(rgb: components)
        case .rgba:
            let components = rgbComponentsOrBlack.add(components: color.rgbComponentsOrBlack, withAlpha: true)
            return CGColor.from(rgb: components)
        case .hsb:
            let components = hsbComponentsOrBlack.add(components: color.hsbComponentsOrBlack, withAlpha: false)
            return CGColor.from(hsb: components)
        case .hsba:
            let components = hsbComponentsOrBlack.add(components: color.hsbComponentsOrBlack, withAlpha: true)
            return CGColor.from(hsb: components)
        }
    }
    
    /// Subtract another color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to subract
    /// - Returns: The merged colors
    public func subtract(_ colorSpace: ColorSpace = .rgb, color: CGColor) -> CGColor {
        switch colorSpace {
        case .rgb:
            let components = rgbComponentsOrBlack.subtract(components: color.rgbComponentsOrBlack, withAlpha: false)
            return CGColor.from(rgb: components)
        case .rgba:
            let components = rgbComponentsOrBlack.subtract(components: color.rgbComponentsOrBlack, withAlpha: true)
            return CGColor.from(rgb: components)
        case .hsb:
            let components = hsbComponentsOrBlack.subtract(components: color.hsbComponentsOrBlack, withAlpha: false)
            return CGColor.from(hsb: components)
        case .hsba:
            let components = hsbComponentsOrBlack.subtract(components: color.hsbComponentsOrBlack, withAlpha: true)
            return CGColor.from(hsb: components)
        }
    }
    
    /// Multiply another color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to multiply with
    /// - Returns: The merged colors
    public func multiply(_ colorSpace: ColorSpace = .rgb, color: CGColor) -> CGColor {
        switch colorSpace {
        case .rgb:
            let components = rgbComponentsOrWhite.multiply(components: color.rgbComponentsOrWhite, withAlpha: false)
            return CGColor.from(rgb: components)
        case .rgba:
            let components = rgbComponentsOrWhite.multiply(components: color.rgbComponentsOrWhite, withAlpha: true)
            return CGColor.from(rgb: components)
        case .hsb:
            let components = hsbComponentsOrWhite.multiply(components: color.hsbComponentsOrWhite, withAlpha: false)
            return CGColor.from(hsb: components)
        case .hsba:
            let components = hsbComponentsOrWhite.multiply(components: color.hsbComponentsOrWhite, withAlpha: true)
            return CGColor.from(hsb: components)
        }
    }
    
    /// Divide another color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to divide with
    /// - Returns: The merged colors
    public func divide(_ colorSpace: ColorSpace = .rgb, color: CGColor) -> CGColor {
        switch colorSpace {
        case .rgb:
            let components = rgbComponentsOrWhite.divide(components: color.rgbComponentsOrWhite, withAlpha: false)
            return CGColor.from(rgb: components)
        case .rgba:
            let components = rgbComponentsOrWhite.divide(components: color.rgbComponentsOrWhite, withAlpha: true)
            return CGColor.from(rgb: components)
        case .hsb:
            let components = hsbComponentsOrWhite.divide(components: color.hsbComponentsOrWhite, withAlpha: false)
            return CGColor.from(hsb: components)
        case .hsba:
            let components = hsbComponentsOrWhite.divide(components: color.hsbComponentsOrWhite, withAlpha: true)
            return CGColor.from(hsb: components)
        }
    }
}

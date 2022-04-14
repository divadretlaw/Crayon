//
//  UIColor.swift
//  Crayon
//
//  Created by David Walter on 20.03.22.
//

#if canImport(UIKit)
import UIKit

extension UIColor {
    /// Checks if the color is dark
    ///
    /// - Returns: Wether the color is dark or not.
    public var isDark: Bool {
        rgbComponents.isDark
    }

    /// Checks if the color is light
    ///
    /// - Returns: Wether the color is light or not.
    public var isLight: Bool {
        !isDark
    }

    /// Calculates the contrast ratio to the given color
    ///
    /// - Parameter to color: Color to check the contrast against
    /// - Returns: The contrast ratio.
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    public func contrast(to color: UIColor) -> CGFloat {
        rgbComponents.contrast(to: color.rgbComponents)
    }

    /// Checks if the contrast ratio is at least 7:1
    ///
    /// - Parameter with color: Color to check the contrast against
    /// - Returns: Wether the color contrast ratio is at least 7:1.
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    public func hasContrast(with color: UIColor) -> Bool {
        rgbComponents.hasContrast(with: color.rgbComponents)
    }

    /// Creates a constant color from the given hex string.
    ///
    /// - Parameter hex: The hex string of the color.
    public convenience init(hex string: String) {
        guard let components = RgbComponents(string) else {
            self.init(white: 1, alpha: 0)
            return
        }

        self.init(components: components)
    }

    /// Returns the hex value as String
    ///
    /// - Parameter prefix: The prefix of the hex value. Defaults to `#`
    /// - Parameter alpha: Wether to include the alpha channel in the hex String
    public func hex(prefix: String? = "#", withAlpha: Bool = false) -> String {
        RgbComponents(color: self).hex(prefix: prefix, withAlpha: withAlpha)
    }
}

// MARK: - Components

extension UIColor {
    var rgbComponents: RgbComponents {
        RgbComponents(color: self)
    }

    var hsbComponents: HsbComponents {
        HsbComponents(color: self)
    }

    convenience init(components: RgbComponents) {
        self.init(red: components.red,
                  green: components.green,
                  blue: components.blue,
                  alpha: components.alpha)
    }

    convenience init(components: HsbComponents) {
        self.init(hue: components.hue,
                  saturation: components.saturation,
                  brightness: components.brightness,
                  alpha: components.alpha)
    }
}

extension RgbComponents {
    init(color: UIColor) {
        var (red, green, blue, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension HsbComponents {
    init(color: UIColor) {
        var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}

// MARK: - Calculations

extension UIColor {
    /// Merge the colors via addition in RGB
    public static func + (lhs: UIColor, rhs: UIColor) -> UIColor {
        lhs.add(color: rhs)
    }

    /// Merge the colors via subtraction in RGB
    public static func - (lhs: UIColor, rhs: UIColor) -> UIColor {
        lhs.subtract(color: rhs)
    }

    /// Merge the colors via multiplication in RGB
    public static func * (lhs: UIColor, rhs: UIColor) -> UIColor {
        lhs.multiply(color: rhs)
    }

    /// Merge the colors via division in RGB
    public static func / (lhs: UIColor, rhs: UIColor) -> UIColor {
        lhs.divide(color: rhs)
    }
    
    /// Add another color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to add
    /// - Returns: The merged colors
    public func add(_ colorSpace: ColorSpace = .rgb, color: UIColor) -> UIColor {
        switch colorSpace {
        case .rgb:
            let components = rgbComponents.add(components: color.rgbComponents, withAlpha: false)
            return UIColor(components: components)
        case .rgba:
            let components = rgbComponents.add(components: color.rgbComponents, withAlpha: true)
            return UIColor(components: components)
        case .hsb:
            let components = rgbComponents.add(components: color.rgbComponents, withAlpha: false)
            return UIColor(components: components)
        case .hsba:
            let components = rgbComponents.add(components: color.rgbComponents, withAlpha: true)
            return UIColor(components: components)
        }
    }
    
    /// Subtract another color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to subract
    /// - Returns: The merged colors
    public func subtract(_ colorSpace: ColorSpace = .rgb, color: UIColor) -> UIColor {
        switch colorSpace {
        case .rgb:
            let components = rgbComponents.subtract(components: color.rgbComponents, withAlpha: false)
            return UIColor(components: components)
        case .rgba:
            let components = rgbComponents.subtract(components: color.rgbComponents, withAlpha: true)
            return UIColor(components: components)
        case .hsb:
            let components = rgbComponents.subtract(components: color.rgbComponents, withAlpha: false)
            return UIColor(components: components)
        case .hsba:
            let components = rgbComponents.subtract(components: color.rgbComponents, withAlpha: true)
            return UIColor(components: components)
        }
    }
    
    /// Multiply another color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to multiply with
    /// - Returns: The merged colors
    public func multiply(_ colorSpace: ColorSpace = .rgb, color: UIColor) -> UIColor {
        switch colorSpace {
        case .rgb:
            let components = rgbComponents.multiply(components: color.rgbComponents, withAlpha: false)
            return UIColor(components: components)
        case .rgba:
            let components = rgbComponents.multiply(components: color.rgbComponents, withAlpha: true)
            return UIColor(components: components)
        case .hsb:
            let components = hsbComponents.multiply(components: color.hsbComponents, withAlpha: false)
            return UIColor(components: components)
        case .hsba:
            let components = hsbComponents.multiply(components: color.hsbComponents, withAlpha: true)
            return UIColor(components: components)
        }
    }
    
    /// Divide another color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to divide with
    /// - Returns: The merged colors
    public func divide(_ colorSpace: ColorSpace = .rgb, color: UIColor) -> UIColor {
        switch colorSpace {
        case .rgb:
            let components = rgbComponents.divide(components: color.rgbComponents, withAlpha: false)
            return UIColor(components: components)
        case .rgba:
            let components = rgbComponents.divide(components: color.rgbComponents, withAlpha: true)
            return UIColor(components: components)
        case .hsb:
            let components = hsbComponents.divide(components: color.hsbComponents, withAlpha: false)
            return UIColor(components: components)
        case .hsba:
            let components = hsbComponents.divide(components: color.hsbComponents, withAlpha: true)
            return UIColor(components: components)
        }
    }
}
#endif

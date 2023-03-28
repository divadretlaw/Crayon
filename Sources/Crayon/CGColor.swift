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

public extension CGColor {
    /// Creates a random color by randomly generating the values in the given color space
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` to generate values in. Defaults to ``ColorSpace/rgb``
    ///     - opacity: An optional degree of alpha (opacity), given in the range `0` to
    ///     `1`. A value of `0` means 100% transparency, while a value of `1`
    ///     means 100% opacity. The default is `1`.
    @available(iOS 13, watchOS 6, tvOS 13, *)
    static func random(_ colorSpace: ColorSpace = .rgb, opacity: Double = 1) -> CGColor {
        switch colorSpace {
        case .rgb, .rgba:
            return CGColor.from(rgb: RgbComponents(alpha: opacity))
        case .hsb, .hsba:
            return CGColor.from(hsb: HsbComponents(alpha: opacity))
        }
    }
    
    /// Checks if the color is dark
    ///
    /// - Returns: Whether the color is dark or not. Returns `nil` if determination wasn't possible
    var isDark: Bool? {
        guard let lightness = rgbComponents?.lightness else { return nil }
        return lightness < 0.5
    }

    /// Calculates the contrast ratio to the given color
    ///
    /// - Parameter to: Color to check the contrast against
    /// - Returns: The contrast ratio. Returns `nil` if determination wasn't possible
    func contrast(to color: CGColor) -> CGFloat? {
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
    /// - Parameter color: Color to check the contrast against
    /// - Returns: Whether the color contrast ratio is at least 7:1. Returns `nil` if determination wasn't possible
    func hasContrast(with color: CGColor) -> Bool? {
        guard let contrast = contrast(to: color) else {
            return nil
        }

        return contrast > 7
    }

    /// Checks if the color is light
    ///
    /// - Returns: Whether the color is light or not. Returns `nil` if determination wasn't possible
    ///
    var isLight: Bool? {
        guard let isDark = isDark else {
            return nil
        }
        return !isDark
    }

    /// Calculates the negative of the color
    ///
    /// - Parameter withOpacity: Optionally provide the negative of the alpha (opacity) too. Defaults to `false`
    /// - Returns: The negative of the color
    @available(iOS 13, watchOS 6, tvOS 13, *)
    func negative(withAlpha: Bool = false) -> CGColor? {
        guard let rgbComponents = rgbComponents else { return nil }
        return CGColor.from(rgb: rgbComponents.negative(withAlpha: withAlpha))
    }
    
    /// Calculates the inversion of the color
    ///
    /// - Returns: The color inverted
    @available(iOS 13, watchOS 6, tvOS 13, *)
    func inverted() -> CGColor? {
        guard let hsbComponents = hsbComponents else { return nil }
        return CGColor.from(hsb: hsbComponents.inverted())
    }
    
    /// Saturates the color
    ///
    /// - Parameter percentage: An optional degree of how much to saturate, given in the range `0` to
    ///     `1`. A value of `0` means no action, while a value of `1` means 100% added saturation.
    ///     The default is `0.1`, or 10%
    /// - Returns: The color saturated by the given percentage
    @available(iOS 13, watchOS 6, tvOS 13, *)
    func saturated(percentage: Double = 0.1) -> CGColor? {
        guard let hsbComponents = hsbComponents else { return nil }
        return CGColor.from(hsb: hsbComponents.saturate(percentage: percentage))
    }
    
    /// Desaturates the color
    ///
    /// - Parameter percentage: An optional degree of how much to desaturate, given in the range `0` to
    ///     `1`. A value of `0` means no action, while a value of `1` means 100% removed saturation.
    ///     The default is `0.1`, or 10%
    /// - Returns: The color desaturated by the given percentage
    @available(iOS 13, watchOS 6, tvOS 13, *)
    func desaturated(percentage: Double = 0.1) -> CGColor? {
        guard let hsbComponents = hsbComponents else { return nil }
        return CGColor.from(hsb: hsbComponents.desaturate(percentage: percentage))
    }
    
    /// Darken the color
    ///
    /// - Parameter percentage: An optional degree of how much to darken, given in the range `0` to
    ///     `1`. A value of `0` means no action, while a value of `1` means 100% darker.
    ///     The default is `0.05`, or 5%
    /// - Returns: The color darkened by the given percentage
    @available(iOS 13, watchOS 6, tvOS 13, *)
    func darkened(percentage: Double = 0.05) -> CGColor? {
        guard let hsbComponents = hsbComponents else { return nil }
        return CGColor.from(hsb: hsbComponents.darken(percentage: percentage))
    }
    
    /// Lighten the color
    ///
    /// - Parameter percentage: An optional degree of how much to lighten, given in the range `0` to
    ///     `1`. A value of `0` means no action, while a value of `1` means 100% lighter.
    ///     The default is `0.05`, or 5%
    /// - Returns: The color lightened by the given percentage
    @available(iOS 13, watchOS 6, tvOS 13, *)
    func lightened(percentage: Double = 0.05) -> CGColor? {
        guard let hsbComponents = hsbComponents else { return nil }
        return CGColor.from(hsb: hsbComponents.lighten(percentage: percentage))
    }
    
    /// Returns the hex value as String
    ///
    /// - Parameter prefix: The prefix of the hex value. Defaults to `#`
    /// - Parameter alpha: Whether to include the alpha channel in the hex String
    ///
    /// - Returns: The hex string or `nil` if the color couldn't be determined
    func hex(prefix: String? = "#", withAlpha: Bool = false) -> String? {
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
    
    /// Mix another color with the color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to mix with
    /// - Returns: The mixed colors
    public func mix(_ colorSpace: ColorSpace = .rgb, color: CGColor) -> CGColor {
        switch colorSpace {
        case .rgb:
            let components = rgbComponentsOrBlack.mix(components: color.rgbComponentsOrBlack, withAlpha: false)
            return CGColor.from(rgb: components)
        case .rgba:
            let components = rgbComponentsOrBlack.mix(components: color.rgbComponentsOrBlack, withAlpha: true)
            return CGColor.from(rgb: components)
        case .hsb:
            let components = hsbComponentsOrBlack.mix(components: color.hsbComponentsOrBlack, withAlpha: false)
            return CGColor.from(hsb: components)
        case .hsba:
            let components = hsbComponentsOrBlack.mix(components: color.hsbComponentsOrBlack, withAlpha: true)
            return CGColor.from(hsb: components)
        }
    }
}

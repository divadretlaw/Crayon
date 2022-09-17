//
//  Color.swift
//  Crayon
//
//  Created by David Walter on 20.03.22.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
public extension Color {
    /// Creates a random color by randomly generating the values in the given color space
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` to generate values in. Defaults to ``ColorSpace/rgb``
    ///     - opacity: An optional degree of opacity, given in the range `0` to
    ///     `1`. A value of `0` means 100% transparency, while a value of `1`
    ///     means 100% opacity. The default is `1`.
    static func random(_ colorSpace: ColorSpace = .rgb, opacity: Double = 1) -> Color {
        switch colorSpace {
        case .rgb, .rgba:
            return Color(components: RgbComponents(alpha: opacity))
        case .hsb, .hsba:
            return Color(components: HsbComponents(alpha: opacity))
        }
    }
    
    /// Checks if the color is dark
    ///
    /// - Returns: Wether the color is dark or not.
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    var isDark: Bool {
        rgbComponents.isDark
    }

    /// Checks if the color is light
    ///
    /// - Returns: Wether the color is light or not.
    ///
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    var isLight: Bool {
        !isDark
    }

    /// Calculates the contrast ratio to the given color
    ///
    /// - Parameter to color: Color to check the contrast against
    /// - Returns: The contrast ratio.
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    func contrast(to color: Color) -> Double {
        rgbComponents.contrast(to: color.rgbComponents)
    }

    /// Checks if the contrast ratio is at least 7:1
    ///
    /// - Parameter with color: Color to check the contrast against
    /// - Returns: Wether the color contrast ratio is at least 7:1.
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    func hasContrast(with color: Color) -> Bool {
        rgbComponents.hasContrast(with: color.rgbComponents)
    }

    /// Calculates the negative of the color
    ///
    /// - Parameter withOpacity: Optionally provide the negative of the opacity too. Defaults to `false`
    /// - Returns: The negative of the color
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    func negative(withOpacity: Bool = false) -> Color {
        Color(components: rgbComponents.negative(withAlpha: withOpacity))
    }
    
    /// Calculates the inversion of the color
    ///
    /// - Returns: The color inverted
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    func inverted() -> Color {
        Color(components: hsbComponents.inverted())
    }
    
    /// Saturates the color
    ///
    /// - Parameter percentage: An optional degree of how much to saturate, given in the range `0` to
    ///     `1`. A value of `0` means no action, while a value of `1` means 100% added saturation.
    ///     The default is `0.1`, or 10%
    /// - Returns: The color saturated by the given percentage
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    func saturated(percentage: Double = 0.1) -> Color {
        Color(components: hsbComponents.saturate(percentage: percentage))
    }
    
    /// Desaturates the color
    ///
    /// - Parameter percentage: An optional degree of how much to desaturate, given in the range `0` to
    ///     `1`. A value of `0` means no action, while a value of `1` means 100% removed saturation.
    ///     The default is `0.1`, or 10%
    /// - Returns: The color desaturated by the given percentage
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    func desaturated(percentage: Double = 0.1) -> Color {
        Color(components: hsbComponents.desaturate(percentage: percentage))
    }
    
    /// Darken the color
    ///
    /// - Parameter percentage: An optional degree of how much to darken, given in the range `0` to
    ///     `1`. A value of `0` means no action, while a value of `1` means 100% darker.
    ///     The default is `0.05`, or 5%
    /// - Returns: The color darkened by the given percentage
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    func darkened(percentage: Double = 0.05) -> Color {
        Color(components: hsbComponents.darken(percentage: percentage))
    }
    
    /// Lighten the color
    ///
    /// - Parameter percentage: An optional degree of how much to lighten, given in the range `0` to
    ///     `1`. A value of `0` means no action, while a value of `1` means 100% lighter.
    ///     The default is `0.05`, or 5%
    /// - Returns: The color lightened by the given percentage
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    func lightened(percentage: Double = 0.05) -> Color {
        Color(components: hsbComponents.lighten(percentage: percentage))
    }

    /// Creates a constant color from the given hex string.
    ///
    /// - Parameters:
    ///   - colorSpace: The profile that specifies how to interpret the color
    ///     for display. The default is ``RGBColorSpace/sRGB``.
    ///   - hex: The hex `String` of the color.
    init(_ colorSpace: Color.RGBColorSpace = .sRGB, hex string: String) {
        guard let components = RgbComponents(string) else {
            self.init(.sRGB, white: 1, opacity: 0)
            return
        }

        self.init(colorSpace, components: components)
    }

    /// Returns the hex value as String
    ///
    /// - Parameter hashPrefix: Wether to prefix the String with `#`
    /// - Parameter alpha: Wether to include the alpha channel in the hex String
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    func hex(prefix: String? = "#", withAlpha: Bool = false) -> String {
        rgbComponents.hex(prefix: prefix, withAlpha: withAlpha)
    }
}

#if !os(watchOS) && canImport(UIKit)
import UIKit

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
public extension Color {
    /// Calculates a readable color on a given color
    ///
    /// - Parameters:
    ///     - color: The color to calculate on
    ///     - onBright: The color to use on bright colors. Defaults to `.black`
    ///     - onDark: The color to use on dark colors. Defaults to `.white`
    /// - Returns: `onBright` or `onDark` depending if the given color is bright or dark
    @available(iOS 15, tvOS 15, *)
    static func on(color: Color, onBright: Color = .black, onDark: Color = .white) -> Color {
        let uiColor = UIColor.on(color: UIColor(color),
                                 onBright: UIColor(onBright),
                                 onDark: UIColor(onDark))
        return Color(uiColor: uiColor)
    }
}
#endif

// MARK: - Components

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
extension Color {
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    var rgbComponents: RgbComponents {
        RgbComponents(color: self) ?? .black
    }

    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    var hsbComponents: HsbComponents {
        HsbComponents(color: self) ?? .black
    }

    init(_ colorSpace: Color.RGBColorSpace = .sRGB, components: RgbComponents) {
        self.init(colorSpace,
                  red: components.red,
                  green: components.green,
                  blue: components.blue,
                  opacity: components.alpha)
    }

    init(components: HsbComponents) {
        self.init(hue: components.hue,
                  saturation: components.saturation,
                  brightness: components.brightness,
                  opacity: components.alpha)
    }
}

@available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
extension RgbComponents {
    init?(color: Color) {
        #if os(macOS)
        let cgColor = color.cgColor ?? NSColor(color).cgColor
        #else
        let cgColor = color.cgColor ?? UIColor(color).cgColor
        #endif

        self.init(color: cgColor)
    }
}

@available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
extension HsbComponents {
    init?(color: Color) {
        #if os(macOS)
        let cgColor = color.cgColor ?? NSColor(color).cgColor
        #else
        let cgColor = color.cgColor ?? UIColor(color).cgColor
        #endif

        self.init(color: cgColor)
    }
}

// MARK: - Calculations

@available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
extension Color {
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
    public static func + (lhs: Self, rhs: Self) -> Self {
        lhs.add(color: rhs)
    }

    /// Merge the colors via subtraction in RGB
    public static func - (lhs: Self, rhs: Self) -> Self {
        lhs.subtract(color: rhs)
    }

    /// Merge the colors via multiplication in RGB
    public static func * (lhs: Self, rhs: Self) -> Self {
        lhs.multiply(color: rhs)
    }

    /// Merge the colors via division in RGB
    public static func / (lhs: Self, rhs: Self) -> Self {
        lhs.divide(color: rhs)
    }
    
    /// Add another color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to add
    /// - Returns: The merged colors
    public func add(_ colorSpace: ColorSpace = .rgb, color: Self) -> Self {
        switch colorSpace {
        case .rgb:
            let components = rgbComponentsOrBlack.add(components: color.rgbComponentsOrBlack, withAlpha: false)
            return Color(components: components)
        case .rgba:
            let components = rgbComponentsOrBlack.add(components: color.rgbComponentsOrBlack, withAlpha: true)
            return Color(components: components)
        case .hsb:
            let components = hsbComponentsOrBlack.add(components: color.hsbComponentsOrBlack, withAlpha: false)
            return Color(components: components)
        case .hsba:
            let components = hsbComponentsOrBlack.add(components: color.hsbComponentsOrBlack, withAlpha: true)
            return Color(components: components)
        }
    }
    
    /// Subtract another color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to subract
    /// - Returns: The merged colors
    public func subtract(_ colorSpace: ColorSpace = .rgb, color: Self) -> Self {
        switch colorSpace {
        case .rgb:
            let components = rgbComponentsOrBlack.subtract(components: color.rgbComponentsOrBlack, withAlpha: false)
            return Color(components: components)
        case .rgba:
            let components = rgbComponentsOrBlack.subtract(components: color.rgbComponentsOrBlack, withAlpha: true)
            return Color(components: components)
        case .hsb:
            let components = hsbComponentsOrBlack.subtract(components: color.hsbComponentsOrBlack, withAlpha: false)
            return Color(components: components)
        case .hsba:
            let components = hsbComponentsOrBlack.subtract(components: color.hsbComponentsOrBlack, withAlpha: true)
            return Color(components: components)
        }
    }
    
    /// Multiply another color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to multiply with
    /// - Returns: The merged colors
    public func multiply(_ colorSpace: ColorSpace = .rgb, color: Self) -> Self {
        switch colorSpace {
        case .rgb:
            let components = rgbComponentsOrWhite.multiply(components: color.rgbComponentsOrWhite, withAlpha: false)
            return Color(components: components)
        case .rgba:
            let components = rgbComponentsOrWhite.multiply(components: color.rgbComponentsOrWhite, withAlpha: true)
            return Color(components: components)
        case .hsb:
            let components = hsbComponentsOrWhite.multiply(components: color.hsbComponentsOrWhite, withAlpha: false)
            return Color(components: components)
        case .hsba:
            let components = hsbComponentsOrWhite.multiply(components: color.hsbComponentsOrWhite, withAlpha: true)
            return Color(components: components)
        }
    }
    
    /// Divide another color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to divide with
    /// - Returns: The merged colors
    public func divide(_ colorSpace: ColorSpace = .rgb, color: Self) -> Self {
        switch colorSpace {
        case .rgb:
            let components = rgbComponentsOrWhite.divide(components: color.rgbComponentsOrWhite, withAlpha: false)
            return Color(components: components)
        case .rgba:
            let components = rgbComponentsOrWhite.divide(components: color.rgbComponentsOrWhite, withAlpha: true)
            return Color(components: components)
        case .hsb:
            let components = hsbComponentsOrWhite.divide(components: color.hsbComponentsOrWhite, withAlpha: false)
            return Color(components: components)
        case .hsba:
            let components = hsbComponentsOrWhite.divide(components: color.hsbComponentsOrWhite, withAlpha: true)
            return Color(components: components)
        }
    }
    
    /// Mix another color with the color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - with color: The color to mix with
    /// - Returns: The mixed colors
    public func mixed(_ colorSpace: ColorSpace = .rgb, with color: Color) -> Color {
        switch colorSpace {
        case .rgb:
            let components = rgbComponents.mixed(components: color.rgbComponents, withAlpha: false)
            return Color(components: components)
        case .rgba:
            let components = rgbComponents.mixed(components: color.rgbComponents, withAlpha: true)
            return Color(components: components)
        case .hsb:
            let components = hsbComponents.mixed(components: color.hsbComponents, withAlpha: false)
            return Color(components: components)
        case .hsba:
            let components = hsbComponents.mixed(components: color.hsbComponents, withAlpha: true)
            return Color(components: components)
        }
    }
}
#endif

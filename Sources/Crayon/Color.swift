//
//  Color.swift
//  Crayon
//
//  Created by David Walter on 20.03.22.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
extension Color {
    /// Checks if the color is dark
    ///
    /// - Returns: Wether the color is dark or not.
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    public var isDark: Bool {
        rgbComponents.isDark
    }

    /// Checks if the color is light
    ///
    /// - Returns: Wether the color is light or not.
    ///
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    public var isLight: Bool {
        !isDark
    }

    /// Calculates the contrast ratio to the given color
    ///
    /// - Parameter to color: Color to check the contrast against
    /// - Returns: The contrast ratio.
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    public func contrast(to color: Color) -> Double {
        rgbComponents.contrast(to: color.rgbComponents)
    }

    /// Checks if the contrast ratio is at least 7:1
    ///
    /// - Parameter with color: Color to check the contrast against
    /// - Returns: Wether the color contrast ratio is at least 7:1.
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    public func hasContrast(with color: Color) -> Bool {
        rgbComponents.hasContrast(with: color.rgbComponents)
    }

    /// Creates a constant color from the given hex string.
    ///
    /// - Parameters:
    ///   - colorSpace: The profile that specifies how to interpret the color
    ///     for display. The default is ``RGBColorSpace/sRGB``.
    ///   - hex: The hex `String` of the color.
    public init(_ colorSpace: Color.RGBColorSpace = .sRGB, hex string: String) {
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
    public func hex(prefix: String? = "#", withAlpha: Bool = false) -> String {
        rgbComponents.hex(prefix: prefix, withAlpha: withAlpha)
    }
}

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
}
#endif

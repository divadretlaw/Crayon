//
//  NSColor.swift
//  Crayon
//
//  Created by David Walter on 20.03.22.
//

#if canImport(AppKit) && os(macOS)
import AppKit

public extension NSColor {
    /// Creates a random color by randomly generating the values in the given color space
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` to generate values in. Defaults to ``ColorSpace/rgb``
    ///     - opacity: An optional degree of alpha (opacity), given in the range `0` to
    ///     `1`. A value of `0` means 100% transparency, while a value of `1`
    ///     means 100% opacity. The default is `1`.
    static func random(_ colorSpace: ColorSpace = .rgb, opacity: Double = 1) -> NSColor {
        switch colorSpace {
        case .rgb, .rgba:
            return NSColor(components: RgbComponents.random(alpha: opacity))
        case .hsb, .hsba:
            return NSColor(components: HsbComponents.random(alpha: opacity))
        }
    }
    
    /// Checks if the color is dark
    ///
    /// - Returns: Whether the color is dark or not.
    var isDark: Bool {
        rgbComponents.isDark
    }

    /// Checks if the color is light
    ///
    /// - Returns: Whether the color is light or not.
    var isLight: Bool {
        !isDark
    }

    /// Calculates the contrast ratio to the given color
    ///
    /// - Parameter to color: Color to check the contrast against
    /// - Returns: The contrast ratio.
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    func contrast(to color: NSColor) -> Double {
        rgbComponents.contrast(to: color.rgbComponents)
    }

    /// Checks if the contrast ratio is at least 7:1
    ///
    /// - Parameter color: Color to check the contrast against
    /// - Returns: Whether the color contrast ratio is at least 7:1.
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    func hasContrast(with color: NSColor) -> Bool {
        rgbComponents.hasContrast(with: color.rgbComponents)
    }

    /// Calculates the negative of the color
    ///
    /// - Parameter withOpacity: Optionally provide the negative of the alpha (opacity) too. Defaults to `false`
    /// - Returns: The negative of the color
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
     func negative(withAlpha: Bool = false) -> NSColor {
        NSColor(components: rgbComponents.negative(withAlpha: withAlpha))
    }
    
    /// Calculates the inversion of the color
    ///
    /// - Returns: The color inverted
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    func inverted() -> NSColor {
        NSColor(components: hsbComponents.inverted())
    }
    
    /// Saturates the color
    ///
    /// - Parameter percentage: An optional degree of how much to saturate, given in the range `0` to
    ///     `1`. A value of `0` means no action, while a value of `1` means 100% added saturation.
    ///     The default is `0.1`, or 10%
    /// - Returns: The color saturated by the given percentage
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    func saturated(percentage: Double = 0.1) -> NSColor {
        NSColor(components: hsbComponents.saturate(percentage: percentage))
    }
    
    /// Desaturates the color
    ///
    /// - Parameter percentage: An optional degree of how much to desaturate, given in the range `0` to
    ///     `1`. A value of `0` means no action, while a value of `1` means 100% removed saturation.
    ///     The default is `0.1`, or 10%
    /// - Returns: The color desaturated by the given percentage
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    func desaturated(percentage: Double = 0.1) -> NSColor {
        NSColor(components: hsbComponents.desaturate(percentage: percentage))
    }
    
    /// Darken the color
    ///
    /// - Parameter percentage: An optional degree of how much to darken, given in the range `0` to
    ///     `1`. A value of `0` means no action, while a value of `1` means 100% darker.
    ///     The default is `0.05`, or 5%
    /// - Returns: The color darkened by the given percentage
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    func darkened(percentage: Double = 0.05) -> NSColor {
        NSColor(components: hsbComponents.darken(percentage: percentage))
    }
    
    /// Lighten the color
    ///
    /// - Parameter percentage: An optional degree of how much to lighten, given in the range `0` to
    ///     `1`. A value of `0` means no action, while a value of `1` means 100% lighter.
    ///     The default is `0.05`, or 5%
    /// - Returns: The color lightened by the given percentage
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    func lightened(percentage: Double = 0.05) -> NSColor {
        NSColor(components: hsbComponents.lighten(percentage: percentage))
    }
    
    /// Creates a constant color from the given hex string.
    ///
    /// - Parameter hex: The hex string of the color.
    convenience init(hex string: String) {
        guard let components = RgbComponents(string) else {
            self.init(white: 1, alpha: 0)
            return
        }

        self.init(components: components)
    }

    /// Returns the hex value as String
    ///
    /// - Parameter prefix: The prefix of the hex value. Defaults to `#`
    /// - Parameter alpha: Whether to include the alpha channel in the hex String
    func hex(prefix: String? = "#", withAlpha: Bool = false) -> String {
        rgbComponents.hex(prefix: prefix, withAlpha: withAlpha)
    }
}

// MARK: - Components

extension NSColor {
    var rgbComponents: RgbComponents {
        RgbComponents(color: self) ?? .black
    }

    var hsbComponents: HsbComponents {
        HsbComponents(color: self) ?? .black
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
    init?(color: NSColor) {
        if let color = color.usingColorSpace(.sRGB) {
            self.init(red: color.redComponent,
                      green: color.greenComponent,
                      blue: color.blueComponent,
                      alpha: color.alphaComponent)
        } else {
            self.init(color: color.cgColor)
        }
    }
}

extension HsbComponents {
    init?(color: NSColor) {
        if let color = color.usingColorSpace(.sRGB) {
            var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
            color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            self.init(hue: hue,
                      saturation: saturation,
                      brightness: brightness,
                      alpha: alpha)
        } else {
            self.init(color: color.cgColor)
        }
    }
}

// MARK: - Calculations

extension NSColor {
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
    public static func + (lhs: NSColor, rhs: NSColor) -> NSColor {
        lhs.add(color: rhs)
    }

    /// Merge the colors via subtraction in RGB
    public static func - (lhs: NSColor, rhs: NSColor) -> NSColor {
        lhs.subtract(color: rhs)
    }

    /// Merge the colors via multiplication in RGB
    public static func * (lhs: NSColor, rhs: NSColor) -> NSColor {
        lhs.multiply(color: rhs)
    }

    /// Merge the colors via division in RGB
    public static func / (lhs: NSColor, rhs: NSColor) -> NSColor {
        lhs.divide(color: rhs)
    }

    /// Add another color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to add
    /// - Returns: The merged colors
    public func add(_ colorSpace: ColorSpace = .rgb, color: NSColor) -> NSColor {
        switch colorSpace {
        case .rgb:
            let components = rgbComponentsOrBlack.add(components: color.rgbComponentsOrBlack, withAlpha: false)
            return NSColor(components: components)
        case .rgba:
            let components = rgbComponentsOrBlack.add(components: color.rgbComponentsOrBlack, withAlpha: true)
            return NSColor(components: components)
        case .hsb:
            let components = rgbComponentsOrBlack.add(components: color.rgbComponentsOrBlack, withAlpha: false)
            return NSColor(components: components)
        case .hsba:
            let components = rgbComponentsOrBlack.add(components: color.rgbComponentsOrBlack, withAlpha: true)
            return NSColor(components: components)
        }
    }
    
    /// Subtract another color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to subract
    /// - Returns: The merged colors
    public func subtract(_ colorSpace: ColorSpace = .rgb, color: NSColor) -> NSColor {
        switch colorSpace {
        case .rgb:
            let components = rgbComponentsOrBlack.subtract(components: color.rgbComponentsOrBlack, withAlpha: false)
            return NSColor(components: components)
        case .rgba:
            let components = rgbComponentsOrBlack.subtract(components: color.rgbComponentsOrBlack, withAlpha: true)
            return NSColor(components: components)
        case .hsb:
            let components = rgbComponentsOrBlack.subtract(components: color.rgbComponentsOrBlack, withAlpha: false)
            return NSColor(components: components)
        case .hsba:
            let components = rgbComponentsOrBlack.subtract(components: color.rgbComponentsOrBlack, withAlpha: true)
            return NSColor(components: components)
        }
    }
    
    /// Multiply another color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to multiply with
    /// - Returns: The merged colors
    public func multiply(_ colorSpace: ColorSpace = .rgb, color: NSColor) -> NSColor {
        switch colorSpace {
        case .rgb:
            let components = rgbComponentsOrWhite.multiply(components: color.rgbComponentsOrWhite, withAlpha: false)
            return NSColor(components: components)
        case .rgba:
            let components = rgbComponentsOrWhite.multiply(components: color.rgbComponentsOrWhite, withAlpha: true)
            return NSColor(components: components)
        case .hsb:
            let components = hsbComponentsOrWhite.multiply(components: color.hsbComponentsOrWhite, withAlpha: false)
            return NSColor(components: components)
        case .hsba:
            let components = hsbComponentsOrWhite.multiply(components: color.hsbComponentsOrWhite, withAlpha: true)
            return NSColor(components: components)
        }
    }
    
    /// Divide another color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to divide with
    /// - Returns: The merged colors
    public func divide(_ colorSpace: ColorSpace = .rgb, color: NSColor) -> NSColor {
        switch colorSpace {
        case .rgb:
            let components = rgbComponentsOrWhite.divide(components: color.rgbComponentsOrWhite, withAlpha: false)
            return NSColor(components: components)
        case .rgba:
            let components = rgbComponentsOrWhite.divide(components: color.rgbComponentsOrWhite, withAlpha: true)
            return NSColor(components: components)
        case .hsb:
            let components = hsbComponentsOrWhite.divide(components: color.hsbComponentsOrWhite, withAlpha: false)
            return NSColor(components: components)
        case .hsba:
            let components = hsbComponentsOrWhite.divide(components: color.hsbComponentsOrWhite, withAlpha: true)
            return NSColor(components: components)
        }
    }
    
    /// Mix another color with the color in the given ``ColorSpace``
    ///
    /// - Parameters:
    ///     - colorSpace: The ``ColorSpace`` within to apply the calculation
    ///     - color: The color to mix with
    /// - Returns: The mixed colors
    public func mix(_ colorSpace: ColorSpace = .rgb, color: NSColor) -> NSColor {
        switch colorSpace {
        case .rgb:
            let components = rgbComponentsOrBlack.mix(components: color.rgbComponentsOrBlack, withAlpha: false)
            return NSColor(components: components)
        case .rgba:
            let components = rgbComponentsOrBlack.mix(components: color.rgbComponentsOrBlack, withAlpha: true)
            return NSColor(components: components)
        case .hsb:
            let components = hsbComponentsOrBlack.mix(components: color.hsbComponentsOrBlack, withAlpha: false)
            return NSColor(components: components)
        case .hsba:
            let components = hsbComponentsOrBlack.mix(components: color.hsbComponentsOrBlack, withAlpha: true)
            return NSColor(components: components)
        }
    }
}
#endif

//
//  NSColor.swift
//  Crayon
//
//  Created by David Walter on 20.03.22.
//

#if canImport(AppKit) && os(macOS)
import AppKit

extension NSColor {
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
    public func contrast(to color: NSColor) -> Double {
        rgbComponents.contrast(to: color.rgbComponents)
    }

    /// Checks if the contrast ratio is at least 7:1
    ///
    /// - Parameter with color: Color to check the contrast against
    /// - Returns: Wether the color contrast ratio is at least 7:1.
    @available(iOS 14, macOS 11, watchOS 7, tvOS 14, *)
    public func hasContrast(with color: NSColor) -> Bool {
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
}
#endif

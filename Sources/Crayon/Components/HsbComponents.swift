//
//  HsbComponents.swift
//  Crayon
//
//  Created by David Walter on 14.04.22.
//

import Foundation

struct HsbComponents: Equatable {
    static var white: HsbComponents {
        HsbComponents(hue: 0, saturation: 0, brightness: 1, alpha: 1)
    }

    static var black: HsbComponents {
        HsbComponents(hue: 0, saturation: 0, brightness: 0, alpha: 1)
    }

    var hue: Double
    var saturation: Double
    var brightness: Double
    var alpha: Double

    init(hue: Double, saturation: Double, brightness: Double, alpha: Double) {
        self.hue = hue.normalized()
        self.saturation = saturation.normalized()
        self.brightness = brightness.normalized()
        self.alpha = alpha.normalized()
    }

    init(rgb: RgbComponents) {
        let max = max(rgb.red, rgb.green, rgb.blue)
        let min = min(rgb.red, rgb.green, rgb.blue)
        let c = max - min

        self.brightness = max

        if c == 0 {
            self.hue = 0
            self.saturation = 0
        } else {
            switch max {
            case rgb.green:
                let segment = (rgb.blue - rgb.red) / c
                let shift: Double = 120 / 60
                self.hue = (segment + shift) * 60 / 360
            case rgb.blue:
                let segment = (rgb.red - rgb.green) / c
                let shift: Double = 240 / 60
                self.hue = (segment + shift) * 60 / 360
            default: // rgb.red
                let segment = (rgb.green - rgb.blue) / c
                var shift: Double = 0 / 60
                if segment < 0 {
                    shift = 360 / 60
                }
                self.hue = (segment + shift) * 60 / 360
            }

            self.saturation = (max - min) / max
        }

        self.alpha = rgb.alpha
    }
    
    init(alpha: Double) {
        self.hue = Double.random(in: 0 ... 1)
        self.saturation = Double.random(in: 0 ... 1)
        self.brightness = Double.random(in: 0 ... 1)
        self.alpha = alpha
    }
    
    func inverted() -> HsbComponents {
        let hue = (hue * 360 + 180).truncatingRemainder(dividingBy: 360) / 360
        return HsbComponents(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    func saturate(percentage: Double) -> HsbComponents {
        HsbComponents(hue: hue,
                      saturation: saturation + percentage.normalized(),
                      brightness: brightness,
                      alpha: alpha)
    }
    
    func desaturate(percentage: Double) -> HsbComponents {
        HsbComponents(hue: hue,
                      saturation: saturation - percentage.normalized(),
                      brightness: brightness,
                      alpha: alpha)
    }
    
    func darken(percentage: Double) -> HsbComponents {
        HsbComponents(hue: hue,
                      saturation: saturation,
                      brightness: brightness - percentage.normalized(),
                      alpha: alpha)
    }
    
    func lighten(percentage: Double) -> HsbComponents {
        HsbComponents(hue: hue,
                      saturation: saturation,
                      brightness: brightness + percentage.normalized(),
                      alpha: alpha)
    }

    // MARK: - Equatable

    static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.hue ~= rhs.hue,
              lhs.saturation ~= rhs.saturation,
              lhs.brightness ~= rhs.brightness,
              lhs.alpha ~= rhs.alpha else { return false }
        return true
    }

    // MARK: - Blending

    func add(components: HsbComponents, withAlpha: Bool) -> HsbComponents {
        HsbComponents(hue: hue + components.hue,
                      saturation: saturation + components.saturation,
                      brightness: brightness + components.brightness,
                      alpha: withAlpha ? alpha + components.alpha : alpha)
    }
    
    func subtract(components: HsbComponents, withAlpha: Bool) -> HsbComponents {
        HsbComponents(hue: hue - components.hue,
                      saturation: saturation - components.saturation,
                      brightness: brightness - components.brightness,
                      alpha: withAlpha ? alpha - components.alpha : alpha)
    }
    
    func multiply(components: HsbComponents, withAlpha: Bool) -> HsbComponents {
        HsbComponents(hue: hue * components.hue,
                      saturation: saturation * components.saturation,
                      brightness: brightness * components.brightness,
                      alpha: withAlpha ? alpha * components.alpha : alpha)
    }
    
    func divide(components: HsbComponents, withAlpha: Bool) -> HsbComponents {
        HsbComponents(hue: hue / components.hue,
                      saturation: saturation / components.saturation,
                      brightness: brightness / components.brightness,
                      alpha: withAlpha ? alpha / components.alpha : alpha)
    }
    
    func mixed(components: HsbComponents, weight: Double = 0.5, withAlpha: Bool) -> HsbComponents {
        let weight = weight.normalized()
        let hue = (1 - weight) * hue + weight * components.hue
        let saturation = (1 - weight) * saturation + weight * components.saturation
        let brightness = (1 - weight) * brightness + weight * components.brightness
        let alpha = (1 - weight) * alpha + weight * components.alpha
        return HsbComponents(hue: hue,
                             saturation: saturation,
                             brightness: brightness,
                             alpha: withAlpha ? alpha : self.alpha)
    }
}

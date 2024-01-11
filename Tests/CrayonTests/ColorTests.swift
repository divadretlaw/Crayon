@testable import Crayon
import SwiftUI
import XCTest

@available(iOS 13, macOS 11, watchOS 6, tvOS 13, *)
final class ColorTests: XCTestCase {
    @available(iOS 14, macOS 12, watchOS 7, tvOS 14, *)
    func testIsDark() {
        XCTAssertTrue(Color.red.isDark)
        XCTAssertTrue(Color.black.isDark)
        XCTAssertFalse(Color.gray.isDark)
        XCTAssertFalse(Color.white.isDark)
    }
    
    @available(iOS 14, macOS 12, watchOS 7, tvOS 14, *)
    func testIsLight() {
        XCTAssertFalse(Color.red.isLight)
        XCTAssertFalse(Color.black.isLight)
        XCTAssertTrue(Color.gray.isLight)
        XCTAssertTrue(Color.white.isLight)
    }

    func testHexInit() {
        XCTAssertEqual(Color(hex: "#FFFFFF"), Color(red: 1, green: 1, blue: 1, opacity: 1))
        XCTAssertEqual(Color(hex: "#000000"), Color(red: 0, green: 0, blue: 0, opacity: 1))
        XCTAssertEqual(Color(hex: "#0000007F"), Color(red: 0, green: 0, blue: 0, opacity: 127 / 255))

        XCTAssertEqual(Color(hex: "#F00"), Color(red: 1, green: 0, blue: 0, opacity: 1))
        XCTAssertEqual(Color(hex: "#F000"), Color(red: 1, green: 0, blue: 0, opacity: 0))
        XCTAssertEqual(Color(hex: "#00FF00"), Color(red: 0, green: 1, blue: 0, opacity: 1))
        XCTAssertEqual(Color(hex: "#0000FF00"), Color(red: 0, green: 0, blue: 1, opacity: 0))

        XCTAssertEqual(Color(hex: "#FFFF007F"), Color(red: 1, green: 1, blue: 0, opacity: 127 / 255))
    }

    @available(iOS 14, macOS 12, watchOS 7, tvOS 14, *)
    func testHex() {
        XCTAssertEqual(Color(.white).hex(), "#FFFFFF")
        XCTAssertEqual(Color(.black).hex(), "#000000")
        XCTAssertEqual(Color(.red).hex(), "#FF0000")
        XCTAssertEqual(Color(.green).hex(), "#00FF00")
        XCTAssertEqual(Color(.blue).hex(), "#0000FF")
    }

    @available(iOS 14, macOS 12, watchOS 7, tvOS 14, *)
    func testContrast() {
        XCTAssertGreaterThan(Color.white.contrast(to: Color.black), 20)
        XCTAssertGreaterThan(Color.black.contrast(to: Color.white), 20)

        XCTAssertEqual(Color.white.hasContrast(with: Color.black), true)
        XCTAssertEqual(Color.white.hasContrast(with: Color.white), false)

        XCTAssertEqual(Color.blue.hasContrast(with: Color.red), false)
        XCTAssertEqual(Color.black.hasContrast(with: Color.red), true)
    }

    @available(iOS 14, macOS 12, watchOS 7, tvOS 14, *)
    func testRgbComponents() {
        checkRGB(color: Color(.sRGB, white: 0.5, opacity: 1), components: RgbComponents(red: 0.5, green: 0.5, blue: 0.5, alpha: 1))
        checkRGB(color: .white, components: RgbComponents(red: 1, green: 1, blue: 1, alpha: 1))
        checkRGB(color: .black, components: RgbComponents(red: 0, green: 0, blue: 0, alpha: 1))
        checkRGB(color: Color(.red), components: RgbComponents(red: 1, green: 0, blue: 0, alpha: 1))
    }

    @available(iOS 14, macOS 12, watchOS 7, tvOS 14, *)
    func checkRGB(color: Color, components: RgbComponents) {
        XCTAssertEqual(RgbComponents(color: color), components)
    }

    @available(iOS 14, macOS 12, watchOS 7, tvOS 14, *)
    func testHsbComponents() {
        checkHSB(color: .white)
        checkHSB(color: .black)
        checkHSB(color: .green)
        #if !os(watchOS)
        checkHSB(color: Color(.systemRed))
        #endif
        checkHSB(color: Color(red: 0.5, green: 0.2, blue: 1))
    }

    @available(iOS 14, macOS 12, watchOS 7, tvOS 14, *)
    func checkHSB(color: Color) {
        guard let lhs = HsbComponents(color: color),
              let rgb = RgbComponents(color: color)
        else {
            return XCTFail()
        }
        XCTAssertEqual(lhs, HsbComponents(rgb: rgb))
    }

    @available(iOS 14, macOS 12, watchOS 7, tvOS 14, *)
    func testAddition() {
        XCTAssertEqual((Color(.red) + Color(.green)).rgbComponents, Color(.yellow).rgbComponents)
        XCTAssertEqual((Color(.red) + Color(.clear)).rgbComponents, Color(.red).rgbComponents)
    }
    
    @available(iOS 14, macOS 12, watchOS 7, tvOS 14, *)
    func testSubtraction() {
        XCTAssertEqual((Color(.yellow) - Color(.green)).rgbComponents, Color(.red).rgbComponents)
        XCTAssertEqual((Color(.red) - Color(.clear)).rgbComponents, Color(.red).rgbComponents)
    }
    
    @available(iOS 14, macOS 12, watchOS 7, tvOS 14, *)
    func testInverted() {
        XCTAssertEqual(Color(.gray).inverted().rgbComponents, Color(.gray).rgbComponents)
    }
    
    @available(iOS 14, macOS 12, watchOS 7, tvOS 14, *)
    func testNegative() {
        XCTAssertEqual(Color(.gray).negative().rgbComponents, Color(.gray).rgbComponents)
    }
    
    @available(iOS 14, macOS 12, watchOS 7, tvOS 14, *)
    func testSaturation() {
        let color = Color.red
        XCTAssertEqual(color.hsbComponents, color.saturated().desaturated().hsbComponents)
    }
    
    @available(iOS 14, macOS 12, watchOS 7, tvOS 14, *)
    func testLightenDarken() {
        let color = Color.red
        XCTAssertTrue(min(color.hsbComponents.brightness + 0.1, 1).isAlmostEqual(to: color.lightened(percentage: 0.1).hsbComponents.brightness))
        XCTAssertEqual(color.rgbComponents, color.darkened().lightened().rgbComponents)
    }
    
    @available(iOS 14, macOS 12, watchOS 7, tvOS 14, *)
    func testRandom() {
        print(Color.random().rgbComponents)
    }
}

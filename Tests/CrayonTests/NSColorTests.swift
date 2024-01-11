#if canImport(AppKit) && os(macOS)
@testable import Crayon
import XCTest

final class NSColorTests: XCTestCase {
    func testIsDark() throws {
        XCTAssertTrue(NSColor(white: 0.25, alpha: 1).isDark)
        XCTAssertFalse(NSColor(white: 0.5, alpha: 1).isDark)
        XCTAssertFalse(NSColor(white: 0.75, alpha: 1).isDark)
    }
    
    func testIsLight() {
        XCTAssertFalse(NSColor.red.isLight)
        XCTAssertFalse(NSColor.black.isLight)
        XCTAssertTrue(NSColor.gray.isLight)
        XCTAssertTrue(NSColor.white.isLight)
    }
    
    func testHexInit() {
        XCTAssertEqual(NSColor(hex: "#FFFFFF"), NSColor(red: 1, green: 1, blue: 1, alpha: 1))
        XCTAssertEqual(NSColor(hex: "#000000"), NSColor(red: 0, green: 0, blue: 0, alpha: 1))
        XCTAssertEqual(NSColor(hex: "#0000007F"), NSColor(red: 0, green: 0, blue: 0, alpha: 127 / 255))
        
        XCTAssertEqual(NSColor(hex: "#F00"), NSColor(red: 1, green: 0, blue: 0, alpha: 1))
        XCTAssertEqual(NSColor(hex: "#F000"), NSColor(red: 1, green: 0, blue: 0, alpha: 0))
        XCTAssertEqual(NSColor(hex: "#00FF00"), NSColor(red: 0, green: 1, blue: 0, alpha: 1))
        XCTAssertEqual(NSColor(hex: "#0000FF00"), NSColor(red: 0, green: 0, blue: 1, alpha: 0))
        
        XCTAssertEqual(NSColor(hex: "#FFFF007F"), NSColor(red: 1, green: 1, blue: 0, alpha: 127 / 255))
    }
    
    func testHex() {
        XCTAssertEqual(NSColor.white.hex(), "#FFFFFF")
        XCTAssertEqual(NSColor.black.hex(), "#000000")
        XCTAssertEqual(NSColor.red.hex(), "#FF0000")
        XCTAssertEqual(NSColor.green.hex(), "#00FF00")
        XCTAssertEqual(NSColor.blue.hex(), "#0000FF")
    }
    
    func testRgbComponents() {
        checkRGB(color: NSColor(white: 0.5, alpha: 1), components: RgbComponents(red: 0.5, green: 0.5, blue: 0.5, alpha: 1))
        checkRGB(color: .white, components: RgbComponents(red: 1, green: 1, blue: 1, alpha: 1))
        checkRGB(color: .black, components: RgbComponents(red: 0, green: 0, blue: 0, alpha: 1))
        checkRGB(color: .red, components: RgbComponents(red: 1, green: 0, blue: 0, alpha: 1))
    }
    
    private func checkRGB(color: NSColor, components: RgbComponents) {
        XCTAssertEqual(RgbComponents(color: color), components)
    }
    
    func testHsbComponents() {
        checkHSB(color: .white)
        checkHSB(color: .black)
        checkHSB(color: .green)
        checkHSB(color: .systemRed)
        checkHSB(color: NSColor(red: 0.5, green: 0.2, blue: 1, alpha: 1))
    }
    
    private func checkHSB(color: NSColor) {
        guard let lhs = HsbComponents(color: color),
              let rgb = RgbComponents(color: color)
        else {
            return XCTFail()
        }
        
        print(lhs, rgb)
        XCTAssertEqual(lhs, HsbComponents(rgb: rgb))
    }
    
    func testAddition() {
        XCTAssertEqual((NSColor.red + NSColor.green).rgbComponents, NSColor.yellow.rgbComponents)
        XCTAssertEqual((NSColor.red + NSColor.clear).rgbComponents, NSColor.red.rgbComponents)
    }
    
    func testSubtraction() {
        XCTAssertEqual((NSColor.yellow - NSColor.green).rgbComponents, NSColor.red.rgbComponents)
        XCTAssertEqual((NSColor.red - NSColor.clear).rgbComponents, NSColor.red.rgbComponents)
    }
    
    func testInverted() {
        XCTAssertEqual(NSColor.gray.inverted().rgbComponents, NSColor.gray.rgbComponents)
    }
    
    func testNegative() {
        XCTAssertEqual(NSColor.gray.negative().rgbComponents, NSColor.gray.rgbComponents)
    }
    
    func testSaturation() {
        let color = NSColor.red
        XCTAssertEqual(color.hsbComponents, color.desaturated().saturated().hsbComponents)
    }
    
    func testLightenDarken() {
        let color = NSColor.red
        XCTAssertTrue(min(color.hsbComponents.brightness + 0.1, 1).isAlmostEqual(to: color.lightened(percentage: 0.1).hsbComponents.brightness))
        XCTAssertEqual(color.rgbComponents, color.darkened().lightened().rgbComponents)
    }
    
    func testRandom() {
        print(NSColor.random().rgbComponents)
    }
}
#endif

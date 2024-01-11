#if canImport(UIKit)
@testable import Crayon
import XCTest

final class UIColorTests: XCTestCase {
    @available(iOS 14, watchOS 7, tvOS 14, *)
    func testIsDark() throws {
        XCTAssertTrue(UIColor(white: 0.25, alpha: 1).isDark)
        XCTAssertFalse(UIColor(white: 0.5, alpha: 1).isDark)
        XCTAssertFalse(UIColor(white: 0.75, alpha: 1).isDark)
    }
    
    @available(iOS 14, watchOS 7, tvOS 14, *)
    func testIsLight() {
        XCTAssertFalse(UIColor.red.isLight)
        XCTAssertFalse(UIColor.black.isLight)
        XCTAssertTrue(UIColor.gray.isLight)
        XCTAssertTrue(UIColor.white.isLight)
    }
    
    func testHexInit() {
        XCTAssertEqual(UIColor(hex: "#FFFFFF"), UIColor(red: 1, green: 1, blue: 1, alpha: 1))
        XCTAssertEqual(UIColor(hex: "#000000"), UIColor(red: 0, green: 0, blue: 0, alpha: 1))
        XCTAssertEqual(UIColor(hex: "#0000007F"), UIColor(red: 0, green: 0, blue: 0, alpha: 127 / 255))
        
        XCTAssertEqual(UIColor(hex: "#F00"), UIColor(red: 1, green: 0, blue: 0, alpha: 1))
        XCTAssertEqual(UIColor(hex: "#F000"), UIColor(red: 1, green: 0, blue: 0, alpha: 0))
        XCTAssertEqual(UIColor(hex: "#00FF00"), UIColor(red: 0, green: 1, blue: 0, alpha: 1))
        XCTAssertEqual(UIColor(hex: "#0000FF00"), UIColor(red: 0, green: 0, blue: 1, alpha: 0))
        
        XCTAssertEqual(UIColor(hex: "#FFFF007F"), UIColor(red: 1, green: 1, blue: 0, alpha: 127 / 255))
    }
    
    func testHex() {
        XCTAssertEqual(UIColor.white.hex(), "#FFFFFF")
        XCTAssertEqual(UIColor.black.hex(), "#000000")
        XCTAssertEqual(UIColor.red.hex(), "#FF0000")
        XCTAssertEqual(UIColor.green.hex(), "#00FF00")
        XCTAssertEqual(UIColor.blue.hex(), "#0000FF")
    }
    
    func testRgbComponents() {
        checkRGB(color: UIColor(white: 0.5, alpha: 1), components: RgbComponents(red: 0.5, green: 0.5, blue: 0.5, alpha: 1))
        checkRGB(color: .white, components: RgbComponents(red: 1, green: 1, blue: 1, alpha: 1))
        checkRGB(color: .black, components: RgbComponents(red: 0, green: 0, blue: 0, alpha: 1))
        checkRGB(color: .red, components: RgbComponents(red: 1, green: 0, blue: 0, alpha: 1))
    }
    
    private func checkRGB(color: UIColor, components: RgbComponents) {
        XCTAssertEqual(RgbComponents(color: color), components)
    }
    
    func testHsbComponents() {
        checkHSB(color: .white)
        checkHSB(color: .black)
        checkHSB(color: .green)
        #if !os(watchOS)
        // .systemRed is not available on watchOS
        checkHSB(color: .systemRed)
        #endif
        checkHSB(color: UIColor(red: 0.5, green: 0.2, blue: 1, alpha: 1))
    }
    
    private func checkHSB(color: UIColor) {
        XCTAssertEqual(HsbComponents(color: color), HsbComponents(rgb: RgbComponents(color: color)))
    }
    
    func testHsbToRgb() {
        let color = UIColor.cyan
        let hsb = HsbComponents(color: color)
        let rgb = RgbComponents(color: color)
        XCTAssertEqual(rgb, RgbComponents(hsb: hsb))
    }
    
    func testAddition() {
        XCTAssertEqual((UIColor.red + UIColor.green).rgbComponents, UIColor.yellow.rgbComponents)
        XCTAssertEqual((UIColor.red + UIColor.clear).rgbComponents, UIColor.red.rgbComponents)
    }
    
    func testSubtraction() {
        XCTAssertEqual((UIColor.yellow - UIColor.green).rgbComponents, UIColor.red.rgbComponents)
        XCTAssertEqual((UIColor.red - UIColor.clear).rgbComponents, UIColor.red.rgbComponents)
    }
    
    func testInverted() {
        XCTAssertEqual(UIColor.gray.inverted().rgbComponents, UIColor.gray.rgbComponents)
    }
    
    func testNegative() {
        XCTAssertEqual(UIColor.gray.negative().rgbComponents, UIColor.gray.rgbComponents)
    }
    
    func testSaturation() {
        let color = UIColor.red
        XCTAssertEqual(color.hsbComponents, color.desaturated().saturated().hsbComponents)
    }
    
    func testLightenDarken() {
        let color = UIColor.red
        XCTAssertTrue(min(color.hsbComponents.brightness + 0.1, 1).isAlmostEqual(to: color.lightened(percentage: 0.1).hsbComponents.brightness))
        XCTAssertEqual(color.rgbComponents, color.darkened().lightened().rgbComponents)
    }
    
    func testRandom() {
        print(UIColor.random().rgbComponents)
    }
}
#endif

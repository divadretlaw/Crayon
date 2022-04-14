#if canImport(UIKit) && !os(watchOS)
@testable import Crayon
import SwiftUI
import XCTest

final class ImageTests: XCTestCase {
    func testUIImage() throws {
        XCTAssertNotNil(UIImage(color: UIColor.red))
    }
    
    @available(iOS 14, macOS 12, watchOS 7, tvOS 14, *)
    func testImage() throws {
        XCTAssertNotNil(Image(color: Color.red))
    }
}
#endif

//
//  Image.swift
//  Crayon
//
//  Created by David Walter on 20.03.22.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UIImage {
    /// Create an `UIImage` from a color
    ///
    /// - Parameter color: The `UIColor` to create the `Image` from.
    convenience init?(color: UIColor?) {
        self.init(color: color?.cgColor)
    }

    /// Create an `UIImage` from a color
    ///
    /// - Parameter color: The `CGColor` to create the `Image` from.
    convenience init?(color: CGColor?) {
        guard let color = color else { return nil }

        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)

        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let cgImage = image?.cgImage {
            self.init(cgImage: cgImage)
        } else if let ciImage = image?.ciImage {
            self.init(ciImage: ciImage)
        } else {
            return nil
        }
    }
}
#endif

#if canImport(UIKit) && canImport(SwiftUI) && !os(watchOS)
import SwiftUI

@available(iOS 13, watchOS 6, tvOS 13, *)
public extension Image {
    /// Create an `Image` from a color
    ///
    /// - Parameter color: The `Color` to create the `Image` from.
    @available(iOS 14, watchOS 7, tvOS 14, *)
    init?(color: Color?) {
        guard let color = color else { return nil }
        let cgColor = color.cgColor ?? UIColor(color).cgColor
        guard let uiImage = UIImage(color: cgColor) else { return nil }
        self.init(uiImage: uiImage)
    }

    /// Create an `Image` from a color
    ///
    /// - Parameter color: The `CGColor` to create the `Image` from.
    init?(color: CGColor?) {
        guard let uiImage = UIImage(color: color) else { return nil }
        self.init(uiImage: uiImage)
    }

    /// Create an `Image` from a color
    ///
    /// - Parameter color: The `UIColor` to create the `Image` from.
    init?(color: UIColor?) {
        guard let uiImage = UIImage(color: color) else { return nil }
        self.init(uiImage: uiImage)
    }
}
#endif

//
//  DoubleExtensions.swift
//  Crayon
//
//  Created by David Walter on 14.04.22.
//

import Foundation

extension Double {
    func normalized() -> Double {
        min(max(self, 0), 1)
    }

    /// If the difference of a `Double` to another is smaller than this
    /// they are considered equal
    static var tolerance = 1e-7

    /// Almost equal
    ///
    /// Compares two `Double` if they are almost equal
    /// See `Double.tolerance`
    static func ~= (lhs: Double, rhs: Double) -> Bool {
        abs(lhs - rhs) < Double.tolerance
    }
}

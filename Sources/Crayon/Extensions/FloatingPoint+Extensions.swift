//
//  FloatingPoint+Extensions.swift
//  Crayon
//
//  Created by David Walter on 11.01.24.
//

import Foundation

extension FloatingPoint {
    func isAlmostEqual(
        to other: Self,
        tolerance: Self = 1e-5
    ) -> Bool {
        guard self.isFinite, other.isFinite else {
            return false
        }
        
        let scale = max(abs(self), abs(other), .leastNormalMagnitude)
        return abs(self - other) < scale * tolerance
    }
    
    func normalized() -> Self {
        min(max(self, 0), 1)
    }
}

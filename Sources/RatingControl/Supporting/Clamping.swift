//
//  Clamping.swift
//
//
//  Created by Edon Valdman on 12/29/23.
//

import Foundation

internal extension BinaryFloatingPoint {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(range.lowerBound, self), range.upperBound)
    }
    
    func clamped(to range: PartialRangeFrom<Self>) -> Self {
        max(range.lowerBound, self)
    }
}

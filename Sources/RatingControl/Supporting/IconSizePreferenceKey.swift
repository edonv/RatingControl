//
//  IconSizePreferenceKey.swift
//
//
//  Created by Edon Valdman on 12/29/23.
//

import SwiftUI

/// Used for summing the sizes (either heights or widths, depending on the axis) of all icons in a ``RatingControl/RatingControl``.
internal struct IconStackSummingSizesPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

/// Used for finding the size (either height or width, depending on the axis) of the full ``RatingControl/RatingControl``.
///
/// This is done by getting the `.maxX`/`.maxY` value of each icon in the coordinate space of the full control frame, then keeping the largest value of all of them.
internal struct IconStackFullSizePreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(nextValue(), value)
    }
    
    static func value(for axis: Axis, in reader: GeometryProxy) -> CGFloat {
        switch axis {
        case .horizontal:
            reader.frame(in: .named("fullControl")).maxX
        case .vertical:
            reader.frame(in: .named("fullControl")).maxY
        }
    }
}

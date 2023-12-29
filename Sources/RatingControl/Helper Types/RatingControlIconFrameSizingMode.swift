//
//  RatingControlIconFrameSizingMode.swift
//
//
//  Created by Edon Valdman on 12/28/23.
//

import Foundation

/// What method to use when laying out each icon in the control.
///
/// This can be set using ``RatingControl/RatingControl/controlSizingMode(_:)``. It defaults to ``useEmptyIconSize``.
public enum RatingControlIconFrameSizingMode: Sendable {
    /// This mode sets the frame size to that of the control's empty icon.
    case useEmptyIconSize
    /// This mode sets the frame size to that of the control's filled icon.
    case useFilledIconSize
    /// This mode leaves each icon state to resize automatically, even if that means the overall frame of the control could move as it changes.
    case dynamic
}

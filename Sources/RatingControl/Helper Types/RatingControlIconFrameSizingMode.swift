//
//  RatingControlIconFrameSizingMode.swift
//
//
//  Created by Edon Valdman on 12/28/23.
//

import Foundation
import SwiftUI

/// What method to use when laying out each icon in the control.
///
/// This can be set using ``SwiftUI/View/ratingControlIconFrameSizingMode(_:)``. It defaults to ``useEmptyIconSize``.
public enum RatingControlIconFrameSizingMode: Sendable {
    /// This mode sets the frame size to that of the control's empty icon.
    case useEmptyIconSize
    /// This mode sets the frame size to that of the control's filled icon.
    case useFilledIconSize
    /// This mode leaves each icon state to resize automatically, even if that means the overall frame of the control could move as it changes.
//    case dynamic
    
    @ViewBuilder
    internal func layoutIcons<EmptyIcon: View, FilledIcon: View>(
        ratingValue: Double,
        iconNumber: Double,
        axis: Axis,
        @ViewBuilder emptyIcon: @escaping () -> EmptyIcon,
        @ViewBuilder filledIcon: @escaping () -> FilledIcon
    ) -> some View {
        // rating 0,  number 1 -> -1 ->   empty, !filled
        // rating 0,  number 3 -> -3 ->   empty, !filled
        // rating .5, number 2 -> -1.5 -> empty, !filled
        // rating 5,  number 2 ->  3 ->   !empty, filled
        // rating 1,  number 1 ->  0 ->   !empty, filled
        
        // rating 2.5, number 3 -> -.5 ->  empty, filled
        // rating 2.5, number 5 -> -2.5 -> empty, filled
        // rating - number = value
        
        // This must make sure iconNumber is a whole number.
        // Otherwise, when iconNumber is a decimal (i.e. last icon when maximumValue is not a whole number),
        // comparisonValue might be `4.5 - 4.5 = 0`, which `4.5` should be the cap.
        // In other words, ratingValue should always be considered out of a whole number.
        let comparisonValue = ratingValue - iconNumber.rounded(.up)
        let clampedValue = comparisonValue.clamped(to: -1...0)
        
        // Separately check if either icon should be shown
        let showEmptyIcon = clampedValue < 0
        let showFilledIcon = clampedValue > -1
        
        // Calc the scale of each icon's mask
        // And use these values in CGSize's based on axis
        
        // If filledIcon is being shown, then set a calc'd ratio.
        // Otherwise, it doesn't matter, because it's hidden.
        let emptyMaskScale = showFilledIcon ? (1 - clampedValue - 1) : 1
        let emptyMaskScaleSize = axis == .horizontal ? CGSize(width: emptyMaskScale, height: 1) : CGSize(width: 1, height: emptyMaskScale)
        
        // If emptyIcon is being shown, then set a calc'd ratio.
        // Otherwise, it doesn't matter, because it's hidden.
        let filledMaskScale = showEmptyIcon ? (clampedValue + 1) : 1
        let filledMaskScaleSize = axis == .horizontal ? CGSize(width: filledMaskScale, height: 1) : CGSize(width: 1, height: filledMaskScale)
        
        // Calculate if empty icon should be cut off if not a whole number
        let emptyIconWholeNumberMaskScale = iconNumber.isWholeNumber ? 1 : iconNumber.truncatingRemainder(dividingBy: 1)
        let emptyIconWholeNumberMaskScaleSize = axis == .horizontal ? CGSize(width: emptyIconWholeNumberMaskScale, height: 1) : CGSize(width: 1, height: emptyIconWholeNumberMaskScale)
        
        // Check what anchors should be used based on axis
        let startUnitPoint: UnitPoint = axis == .horizontal ? .leading : .top
        let endUnitPoint: UnitPoint = axis == .horizontal ? .trailing : .bottom
        
        // Layout
        switch self {
        case .useEmptyIconSize:
            emptyIcon()
                .maskBackport {
                    Rectangle()
                        .scale(emptyIconWholeNumberMaskScaleSize, anchor: startUnitPoint)
                }
                .maskBackport {
                    Rectangle()
                        .scale(emptyMaskScaleSize, anchor: endUnitPoint)
                }
                .opacity(showEmptyIcon ? 1 : 0)
                .overlayBackport {
                    Color.clear
                        .overlayBackport {
                            filledIcon()
                        }
                        .maskBackport {
                            Rectangle()
                                .scale(filledMaskScaleSize, anchor: startUnitPoint)
                        }
                        .opacity(showFilledIcon ? 1 : 0)
                }
            
        case .useFilledIconSize:
            filledIcon()
                .maskBackport {
                    Rectangle()
                        .scale(filledMaskScaleSize, anchor: startUnitPoint)
                }
                .opacity(showFilledIcon ? 1 : 0)
                .overlayBackport {
                    Color.clear
                        .overlayBackport {
                            emptyIcon()
                        }
                        .maskBackport {
                            Rectangle()
                                .scale(emptyIconWholeNumberMaskScaleSize, anchor: startUnitPoint)
                        }
                        .maskBackport {
                            Rectangle()
                                .scale(emptyMaskScaleSize, anchor: endUnitPoint)
                        }
                        .opacity(showEmptyIcon ? 1 : 0)
                }
            
//        case .dynamic:
//            /*H*/ZStack/*(spacing: 0)*/ {
//                if showFilledIcon {
//                    filledIcon()
//                        .maskBackport {
//                            Rectangle()
//                                .scale(filledMaskScaleSize, anchor: startUnitPoint)
//                        }
//                }
//                
//                if showEmptyIcon {
//                    emptyIcon()
//                        .maskBackport {
//                            Rectangle()
//                                .scale(emptyMaskScaleSize, anchor: endUnitPoint)
//                        }
//                }
//            }
        }
    }
}

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
        // If filledIcon is being shown, then set a calc'd ratio.
        // Otherwise, it doesn't matter, because it's hidden.
        let emptyMaskScale = showFilledIcon ? (1 - clampedValue - 1) : 1
        // If emptyIcon is being shown, then set a calc'd ratio.
        // Otherwise, it doesn't matter, because it's hidden.
        let filledMaskScale = showEmptyIcon ? (clampedValue + 1) : 1
        
        // Calculate if empty icon should be cut off if not a whole number
        let emptyIconWholeNumberMaskScale = iconNumber.isWholeNumber ? 1 : iconNumber.truncatingRemainder(dividingBy: 1)
        
        // Layout
        switch self {
        case .useEmptyIconSize:
            emptyIcon()
                .maskBackport {
                    Rectangle()
                        .scale(x: emptyIconWholeNumberMaskScale, anchor: .leading)
                }
                .maskBackport {
                    Rectangle()
                        .scale(x: emptyMaskScale, anchor: .trailing)
                }
                .opacity(showEmptyIcon ? 1 : 0)
                .overlayBackport {
                    Color.clear
                        .overlayBackport {
                            filledIcon()
                        }
                        .maskBackport {
                            Rectangle()
                                .scale(x: filledMaskScale, anchor: .leading)
                        }
                        .opacity(showFilledIcon ? 1 : 0)
                }
            
        case .useFilledIconSize:
            filledIcon()
                .maskBackport {
                    Rectangle()
                        .scale(x: filledMaskScale, anchor: .leading)
                }
                .opacity(showFilledIcon ? 1 : 0)
                .overlayBackport {
                    Color.clear
                        .overlayBackport {
                            emptyIcon()
                        }
                        .maskBackport {
                            Rectangle()
                                .scale(x: emptyIconWholeNumberMaskScale, anchor: .leading)
                        }
                        .maskBackport {
                            Rectangle()
                                .scale(x: emptyMaskScale, anchor: .trailing)
                        }
                        .opacity(showEmptyIcon ? 1 : 0)
                }
            
//        case .dynamic:
//            /*H*/ZStack/*(spacing: 0)*/ {
//                if showFilledIcon {
//                    filledIcon()
//                        .maskBackport {
//                            Rectangle()
//                                .scale(x: filledMaskScale, anchor: .leading)
//                        }
//                }
//                
//                if showEmptyIcon {
//                    emptyIcon()
//                        .maskBackport {
//                            Rectangle()
//                                .scale(x: emptyMaskScale, anchor: .trailing)
//                        }
//                }
//            }
        }
    }
}

//
//  RatingView.swift
//
//
//  Created by Edon Valdman on 12/28/23.
//

import SwiftUI

/// A control for setting a "rating".
///
/// Anything can be used for empty and filled images (they can be any type of view, not just `Image`s).
@available(iOS 13, macOS 10.15, macCatalyst 13, tvOS 13.0, watchOS 6, visionOS 1, *)
public struct RatingControl<EmptyIcon: View, FilledIcon: View>: View {
    // MARK: Environment Values
    
    @Environment(\.layoutDirection)
    private var layoutDirection
    
    // MARK: Custom Environment Values
    
    @Environment(\.ratingControlIconFrameSizingMode)
    private var iconFrameSizingMode
    @Environment(\.ratingControlIconSpacing)
    private var iconSpacing
    @Environment(\.ratingControlEmptyIconStyle)
    private var emptyIconStyle
    @Environment(\.ratingControlFilledIconStyle)
    private var filledIconStyle
    
    // MARK: Init Properties
    
    private let axis: Axis
    private let maximumRating: Double
    private var filledSymbolVariant: BackportSymbolVariants = .none
    
    // MARK: Binding/ViewBuilder Properties
    
    @Binding private var rating: Double
    @ViewBuilder
    private var emptyIcon: () -> EmptyIcon
    @ViewBuilder
    private var filledIcon: () -> FilledIcon
    
    /// Creates a `RatingControl`.
    /// - Parameters:
    ///   - rating: The binding to a value you provide.
    ///   - axis: The axis on which to lay out the control.
    ///   - maximumRating: The maximum possible value. This is how many icons will be laid out.
    ///   - emptyIcon: A view used for every number increment past the current `rating` value, used to show the possible range of values.
    ///   - filledIcon: A view used for every number increment up to the current `rating` value, used to show the current value.
    public init<V: BinaryFloatingPoint>(
        _ rating: Binding<V>,
        axis: Axis = .horizontal,
        maximumRating: V = 5,
        @ViewBuilder emptyIcon: @escaping () -> EmptyIcon,
        @ViewBuilder filledIcon: @escaping () -> FilledIcon
    ) {
        self.axis = axis
        // Ensure it's not set to anything less than 1
        self.maximumRating = Double(maximumRating).clamped(to: 1...)
        
        self._rating = .init {
            Double(rating.wrappedValue.clamped(to: 0...maximumRating))
        } set: { newValue in
            rating.wrappedValue = V(newValue).clamped(to: 0...maximumRating)
        }
        
        self.emptyIcon = emptyIcon
        self.filledIcon = filledIcon
    }
    
    private var iterationStride: Array<Double> {
        let start = Array(stride(from: 1, through: maximumRating, by: 1))
        
        // Continue if max is not a whole number
        guard !maximumRating.isWholeNumber else { return start }
        return start + CollectionOfOne(maximumRating)
    }
    
    public var body: some View {
        stack {
            ForEach(iterationStride, id: \.self) { n in
                #if !os(tvOS)
                label(for: n)
                    .backgroundBackport {
                        GeometryReader { reader in
                            Color.clear
                                .preference(key: IconStackFullSizePreferenceKey.self, value: IconStackFullSizePreferenceKey.value(for: axis, in: reader))
                                .anchorPreference(key: IconStackSummingSizesPreferenceKey.self, value: .bounds) { anchor in
                                    switch axis {
                                    case .horizontal:
                                        reader[anchor].width
                                    case .vertical:
                                        reader[anchor].height
                                    }
                                }
                        }
                    }
                    .onTapGesture {
                        tappedIcon(n)
                    }
                #else
                Button {
                    tappedIcon(n)
                } label: {
                    label(for: n)
                }
                .buttonStyle(.plain)
                #endif
            }
        }
        #if !os(tvOS)
        .coordinateSpace(name: "fullControl")
        .onPreferenceChange(IconStackSummingSizesPreferenceKey.self) { newSize in
            totalAxisSizeAllIcons = newSize
        }
        .onPreferenceChange(IconStackFullSizePreferenceKey.self) { newSize in
            fullFrameMainDimension = newSize
        }
        .gesture(drag)
        #endif
    }
    
    private func tappedIcon(_ number: Double) {
        if number == 1 && rating == 1 {
            rating = 0
        } else {
            rating = number
        }
    }
    
    #if !os(tvOS)
    @State private var totalAxisSizeAllIcons: CGFloat = 0
    @State private var fullFrameMainDimension: CGFloat = 0
    private var drag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let newRating = calcRating(from: value.location)
                if rating != newRating {
                    rating = newRating
                }
            }
    }
    
    private func calcRating(from touchPosition: CGPoint) -> Double {
        var positionValue: CGFloat
        switch axis {
        case .horizontal:
            positionValue = touchPosition.x
        case .vertical:
            positionValue = touchPosition.y
        }
        
        if layoutDirection == .rightToLeft {
            positionValue = fullFrameMainDimension - positionValue
        }
        
        // If positionValue is at min or max allowed value, return the respective bound.
        // As opposed to clamping, it's better to just return so no more math is done
        guard positionValue > 0 else { return 0 }
        guard positionValue < fullFrameMainDimension else { return maximumRating }
        
        // Calc spacing by gettin difference between full size of control and sum of sizes of icons
        let spacing = (fullFrameMainDimension - totalAxisSizeAllIcons) / CGFloat(maximumRating - 1)
        // This won't work with `.dynamic` mode. Instead, refactor IconStackSummingSizesPreferenceKey to use a custom struct that is a dictionary or array storing the sizes of each icon
        let iconDimension = totalAxisSizeAllIcons / maximumRating.rounded(.up)
        
        // incremently remove spacing and icon width from clampedPosValue until less than iconWidth
        var posValueLocal = positionValue
        var selectedIconNum = 0.0
        while posValueLocal >= iconDimension {
            posValueLocal -= (spacing + iconDimension)
            selectedIconNum += 1
        }
        
        // If local position is between -spacing and `0`, then touch position is in a spacing gap between icons,
        // so just return the selected number icon
        guard !(-spacing..<0).contains(posValueLocal) else { return selectedIconNum }
        
        // Calc final value by dividing the local space posValue by iconWidth, then adding selectingIconNumNew
        // i.e. (24 / 48) + 3 = 3.5
        return Double((posValueLocal / iconDimension) + selectedIconNum)
            .clamped(to: 0...maximumRating)
    }
    #endif
    
    @ViewBuilder
    private func stack(@ViewBuilder content: () -> some View) -> some View {
        switch axis {
        case .horizontal:
            HStack(spacing: iconSpacing) {
                content()
            }
        case .vertical:
            VStack(spacing: iconSpacing) {
                content()
            }
        }
    }
    
    @ViewBuilder
    private func label(for number: Double) -> some View {
        iconFrameSizingMode.layoutIcons(ratingValue: rating, iconNumber: number) {
            emptyIcon()
                .foregroundStyleBackport(emptyIconStyle)
        } filledIcon: {
            filledIconWithVariant
                .foregroundStyleBackport(filledIconStyle)
        }
    }
    
    @ViewBuilder
    private var filledIconWithVariant: some View {
        if #available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *) {
            filledIcon()
                .symbolVariant(filledSymbolVariant.symbolVariants)
        } else {
            filledIcon()
        }
    }
}

// MARK: - Init with Symbol + Variant

extension RatingControl where EmptyIcon == Image, FilledIcon == Image {
    /// Creates a `RatingControl` with a system symbol image as the base icon, while applying the provided [`SymbolVariants`](https://developer.apple.com/documentation/swiftui/symbolvariants) when an icon is filled.
    ///
    /// This initializer is only available on OS's that supports `SymbolVariants`. To get this same effect on older OS's, use a different initializer manually including the variant(s) in the system image name for the filled icon.
    /// - Parameters:
    ///   - rating: The binding to a value you provide.
    ///   - axis: The axis on which to lay out the control.
    ///   - maximumRating: The maximum possible value. This is how many icons will be laid out.
    ///   - systemImageName: The name of the system symbol image to use for every number increment past the current `rating` value, used to show the possible range of values. It's also used as the for the filled icon, but with `filledSymbolVariant` applied to it.
    ///   - filledSymbolVariant: The variant to use for the filled icon. The filled icon is used for every number increment up to the current `rating` value, used to show the current value.
    @available(iOS 15, macOS 12, macCatalyst 15, tvOS 15, watchOS 8, visionOS 1, *)
    public init<V: BinaryFloatingPoint>(
        _ rating: Binding<V>,
        axis: Axis = .horizontal,
        maximumRating: V = 5,
        systemImageName: String,
        filledSymbolVariant: SymbolVariants
    ) {
        self.init(rating, axis: axis, maximumRating: maximumRating) {
            Image(systemName: systemImageName)
        } filledIcon: {
            Image(systemName: systemImageName)
        }
        
        self.filledSymbolVariant = .init(variant: filledSymbolVariant)
    }
}

@available(iOS 16, macOS 13, macCatalyst 16, tvOS 16, watchOS 9, visionOS 1, *)
private struct RatingViewPreview: View {
    @State private var rating: Double = 0
    
    var body: some View {
        RatingControl($rating, systemImageName: "star", filledSymbolVariant: .fill.circle)
//            .ratingControlIconSpacing(0)
//            .ratingControlIconColor(.blue.gradient)
            .ratingControlEmptyIconStyle(.blue.gradient)
            .ratingControlFilledIconStyle(.orange.gradient)
//            .ratingControlIconFrameSizingMode(.dynamic)
    }
}

@available(iOS 16, macOS 13, macCatalyst 16, tvOS 16, watchOS 9, visionOS 1, *)
#Preview {
    RatingViewPreview()
        .font(.largeTitle)
//        .environment(\.layoutDirection, .rightToLeft)
}

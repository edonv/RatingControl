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
    private let maximumRating: Int
    private var filledSymbolVariant: BackportSymbolVariants = .none
    
    // MARK: Binding/ViewBuilder Properties
    
    @Binding private var rating: Int
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
    public init(
        _ rating: Binding<Int>,
        axis: Axis = .horizontal,
        maximumRating: Int = 5,
        @ViewBuilder emptyIcon: @escaping () -> EmptyIcon,
        @ViewBuilder filledIcon: @escaping () -> FilledIcon
    ) {
        self.axis = axis
        // Ensure it's not set to anything less than 1
        self.maximumRating = max(maximumRating, 1)
        
        self._rating = .init {
            min(max(rating.wrappedValue, 0), maximumRating)
        } set: { newValue in
            rating.wrappedValue = min(max(newValue, 0), maximumRating)
        }
        
        self.emptyIcon = emptyIcon
        self.filledIcon = filledIcon
    }
    
    public var body: some View {
        stack {
            ForEach(1...maximumRating, id: \.self) { n in
                #if !os(tvOS)
                label(for: n)
                    .onTapGesture {
                        if n == 1 && rating == 1 {
                            rating = 0
                        } else {
                            rating = n
                        }
                    }
                #else
                Button {
                    if n == 1 && rating == 1 {
                        rating = 0
                    } else {
                        rating = n
                    }
                } label: {
                    label(for: n)
                }
                .buttonStyle(.plain)
                #endif
            }
        }
        #if !os(tvOS)
        .backgroundBackport {
            GeometryReader { reader in
                Color.clear
                    .onChangeBackport(of: reader.size) { newValue in
                        frameSize = newValue
                    }
            }
        }
        .gesture(drag)
        #endif
    }
    
    #if !os(tvOS)
    @State private var frameSize: CGSize = .zero
    private var drag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                var positionValue: CGFloat
                let frameDimension: CGFloat
                switch axis {
                case .horizontal:
                    positionValue = value.location.x
                    frameDimension = frameSize.width
                case .vertical:
                    positionValue = value.location.y
                    frameDimension = frameSize.height
                }
                
                if layoutDirection == .rightToLeft {
                    positionValue = frameDimension - positionValue
                }
                
                let clampedPosValue = min(max(positionValue, 0), frameDimension)
                let newValue = (CGFloat(maximumRating) * clampedPosValue / frameDimension).rounded(.up)
                
                if rating != Int(newValue) {
                    rating = Int(newValue)
                }
            }
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
    private func label(for number: Int) -> some View {
        switch iconFrameSizingMode {
        case .useEmptyIconSize:
            styledEmptyIcon(for: number)
                .overlayBackport {
                    styledFilledIcon(for: number)
                }
            
        case .useFilledIconSize:
            styledFilledIcon(for: number)
                .overlayBackport {
                    styledEmptyIcon(for: number)
                }
            
        case .dynamic:
            if number > rating {
                styledEmptyIcon(for: number)
            } else {
                styledFilledIcon(for: number)
            }
        }
    }
    
    @ViewBuilder
    private func styledEmptyIcon(for number: Int) -> some View {
        emptyIcon()
            .foregroundStyleBackport(emptyIconStyle)
            .opacity(number > rating ? 1 : 0)
    }
    
    @ViewBuilder
    private func styledFilledIcon(for number: Int) -> some View {
        filledIconWithVariant
            .foregroundStyleBackport(filledIconStyle)
            .opacity(number > rating ? 0 : 1)
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
    init(
        _ rating: Binding<Int>,
        axis: Axis = .horizontal,
        maximumRating: Int = 5,
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
    @State private var rating: Int = 0
    
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

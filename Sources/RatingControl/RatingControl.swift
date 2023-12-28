//
//  RatingView.swift
//
//
//  Created by Edon Valdman on 12/28/23.
//

import SwiftUI

@available(iOS 13, macOS 10.15, macCatalyst 13, tvOS 13.0, watchOS 6, visionOS 1, *)
public struct RatingControl<Empty: View, Selected: View>: View {
    @Environment(\.layoutDirection)
    private var layoutDirection
    
    private let axis: Axis
    private let maximumRating: Int
    private var stackSpacing: CGFloat? = nil
    
    private var selectedSymbolVariants: BackportSymbolVariants
    
    @Binding private var rating: Int
    @ViewBuilder
    private var emptyLabel: () -> Empty
    @ViewBuilder
    private var selectedLabel: () -> Selected
    
    public init(
        _ rating: Binding<Int>,
        axis: Axis = .horizontal,
        maximumRating: Int = 5,
        @ViewBuilder emptyLabel: @escaping () -> Empty,
        @ViewBuilder selectedLabel: @escaping () -> Selected
    ) {
        self.axis = axis
        // Ensure it's not set to anything less than 1
        self.maximumRating = max(maximumRating, 1)
        
        self._rating = .init {
            min(max(rating.wrappedValue, 0), maximumRating)
        } set: { newValue in
            rating.wrappedValue = min(max(newValue, 0), maximumRating)
        }
        
        self.emptyLabel = emptyLabel
        self.selectedLabel = selectedLabel
        self.selectedSymbolVariants = .none
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
            HStack(spacing: stackSpacing) {
                content()
            }
        case .vertical:
            VStack(spacing: stackSpacing) {
                content()
            }
        }
    }
    
    @ViewBuilder
    private func label(for number: Int) -> some View {
        emptyLabel()
            .opacity(number > rating ? 1 : 0)
            .overlayBackport {
                finalSelectedLabel
                    .opacity(number > rating ? 0 : 1)
            }
    }
    
    @ViewBuilder
    private var finalSelectedLabel: some View {
        if #available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *) {
            selectedLabel()
                .symbolVariant(selectedSymbolVariants.symbolVariants)
        } else {
            selectedLabel()
        }
    }
    
    // MARK: Modifiers
    
    public func labelSpacing(_ spacing: CGFloat?) -> Self {
        var new = self
        new.stackSpacing = spacing
        return new
    }
}

extension RatingControl where Empty == Image, Selected == Image {
    @available(iOS 15, macOS 12, macCatalyst 15, tvOS 15, watchOS 8, visionOS 1, *)
    init(
        _ rating: Binding<Int>,
        axis: Axis = .horizontal,
        maximumRating: Int = 5,
        systemImageName: String,
        selectedSymbolVariants: SymbolVariants
    ) {
        self.init(rating, axis: axis, maximumRating: maximumRating) {
            Image(systemName: systemImageName)
        } selectedLabel: {
            Image(systemName: systemImageName)
        }
        
        self.selectedSymbolVariants = .init(variant: selectedSymbolVariants)
    }
}

@available(iOS 15, macOS 12, macCatalyst 15, tvOS 15, watchOS 8, visionOS 1, *)
private struct RatingViewPreview: View {
    @State private var rating: Int = 0
    
    var body: some View {
        RatingControl($rating, systemImageName: "star", selectedSymbolVariants: .fill)
//            .labelSpacing(0)
        //    RatingView(rating: .constant(3), maximumRating: 5, stackSpacing: nil) {
        //        Image(systemName: "star")
        //    } selectedLabel: {
        //        Image(systemName: "star")
        //            .symbolVariant(.fill)
        //    }
    }
}

@available(iOS 15, macOS 12, macCatalyst 15, tvOS 15, watchOS 8, visionOS 1, *)
#Preview {
    RatingViewPreview()
        .font(.largeTitle)
//        .environment(\.layoutDirection, .rightToLeft)
}

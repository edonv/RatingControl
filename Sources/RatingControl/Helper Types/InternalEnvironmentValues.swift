//
//  InternalEnvironmentValues.swift
//
//
//  Created by Edon Valdman on 12/28/23.
//

import SwiftUI

// MARK: - RatingControlIconSpacing

private struct RatingControlIconSpacingEnvironmentKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

extension EnvironmentValues {
    internal var ratingControlIconSpacing: CGFloat? {
        get { self[RatingControlIconSpacingEnvironmentKey.self] }
        set { self[RatingControlIconSpacingEnvironmentKey.self] = newValue }
    }
}

extension View {
    /// This sets the spacing between icons in a ``RatingControl/RatingControl``.
    ///
    /// The default value is `nil`, which uses the system's default spacing.
    @ViewBuilder
    public func ratingControlIconSpacing(_ spacing: CGFloat?) -> some View {
        self.environment(\.ratingControlIconSpacing, spacing)
    }
}

// MARK: - RatingControlIconFrameSizingMode

private struct RatingControlIconFrameSizingModeEnvironmentKey: EnvironmentKey {
    static let defaultValue: RatingControlIconFrameSizingMode = .useEmptyIconSize
}

extension EnvironmentValues {
    internal var ratingControlIconFrameSizingMode: RatingControlIconFrameSizingMode {
        get { self[RatingControlIconFrameSizingModeEnvironmentKey.self] }
        set { self[RatingControlIconFrameSizingModeEnvironmentKey.self] = newValue }
    }
}

extension View {
    /// This sets the mode used for sizing icon frames in a ``RatingControl/RatingControl``.
    ///
    /// The default value is ``RatingControl/RatingControlIconFrameSizingMode/useEmptyIconSize``.
    @ViewBuilder
    public func ratingControlIconFrameSizingMode(_ mode: RatingControlIconFrameSizingMode) -> some View {
        self.environment(\.ratingControlIconFrameSizingMode, mode)
    }
}

// MARK: EmptyIconStyle

private struct RatingControlEmptyIconStyleEnvironmentKey: EnvironmentKey {
    static let defaultValue: AnyShapeStyleBackport = .primary
}

extension EnvironmentValues {
    internal var ratingControlEmptyIconStyle: AnyShapeStyleBackport {
        get { self[RatingControlEmptyIconStyleEnvironmentKey.self] }
        set { self[RatingControlEmptyIconStyleEnvironmentKey.self] = newValue }
    }
}

extension View {
    /// Sets a ``RatingControl/RatingControl``'s empty icons to use a given style.
    ///
    /// The default value is [`primary`](https://developer.apple.com/documentation/swiftui/hierarchicalshapestyle/primary).
    @available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15, watchOS 8.0, visionOS 1.0, *)
    @ViewBuilder
    public func ratingControlEmptyIconStyle<S: ShapeStyle>(_ style: S) -> some View {
        self.environment(\.ratingControlEmptyIconStyle, AnyShapeStyleBackport.shapeStyle(style))
    }
    
    /// Sets a ``RatingControl/RatingControl``'s empty icons to use a given color.
    ///
    /// The default value is [`HierarchicalShapeStyle.primary`](https://developer.apple.com/documentation/swiftui/hierarchicalshapestyle/primary), if available (iOS 15+, etc.). Otherwise, it's [`Color.primary`](https://developer.apple.com/documentation/swiftui/color/primary).
    @available(iOS, introduced: 13.0, deprecated: 17.0, renamed: "ratingControlEmptyIconStyle(_:)")
    @available(macOS, introduced: 10.15, deprecated: 14.0, renamed: "ratingControlEmptyIconStyle(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 17.0, renamed: "ratingControlEmptyIconStyle(_:)")
    @available(watchOS, introduced: 6.0, deprecated: 10.0, renamed: "ratingControlEmptyIconStyle(_:)")
    @available(visionOS, introduced: 1.0, deprecated: 1.0, renamed: "ratingControlEmptyIconStyle(_:)")
    @ViewBuilder
    public func ratingControlEmptyIconColor(_ color: Color) -> some View {
        self.environment(\.ratingControlEmptyIconStyle, AnyShapeStyleBackport.color(color))
    }
}

// MARK: FilledIconStyle

private struct RatingControlFilledIconStyleEnvironmentKey: EnvironmentKey {
    static let defaultValue: AnyShapeStyleBackport = .primary
}

extension EnvironmentValues {
    internal var ratingControlFilledIconStyle: AnyShapeStyleBackport {
        get { self[RatingControlFilledIconStyleEnvironmentKey.self] }
        set { self[RatingControlFilledIconStyleEnvironmentKey.self] = newValue }
    }
}

extension View {
    /// Sets a ``RatingControl/RatingControl``'s filled icons to use a given style.
    ///
    /// The default value is [`primary`](https://developer.apple.com/documentation/swiftui/hierarchicalshapestyle/primary).
    @available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15, watchOS 8.0, visionOS 1.0, *)
    @ViewBuilder
    public func ratingControlFilledIconStyle<S: ShapeStyle>(_ style: S) -> some View {
        self.environment(\.ratingControlFilledIconStyle, AnyShapeStyleBackport.shapeStyle(style))
    }
    
    /// Sets a ``RatingControl/RatingControl``'s filled icons to use a given color.
    ///
    /// The default value is [`HierarchicalShapeStyle.primary`](https://developer.apple.com/documentation/swiftui/hierarchicalshapestyle/primary), if available (iOS 15+, etc.). Otherwise, it's [`Color.primary`](https://developer.apple.com/documentation/swiftui/color/primary).
    @available(iOS, introduced: 13.0, deprecated: 17.0, renamed: "ratingControlFilledIconStyle(_:)")
    @available(macOS, introduced: 10.15, deprecated: 14.0, renamed: "ratingControlFilledIconStyle(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 17.0, renamed: "ratingControlFilledIconStyle(_:)")
    @available(watchOS, introduced: 6.0, deprecated: 10.0, renamed: "ratingControlFilledIconStyle(_:)")
    @available(visionOS, introduced: 1.0, deprecated: 1.0, renamed: "ratingControlFilledIconStyle(_:)")
    @ViewBuilder
    public func ratingControlFilledIconColor(_ color: Color) -> some View {
        self.environment(\.ratingControlFilledIconStyle, AnyShapeStyleBackport.color(color))
    }
}

// MARK: BothIconStyles

extension View {
    /// Sets all icons in a ``RatingControl/RatingControl`` to use a given style.
    ///
    /// The default value is [`primary`](https://developer.apple.com/documentation/swiftui/hierarchicalshapestyle/primary).
    @available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15, watchOS 8.0, visionOS 1.0, *)
    @ViewBuilder
    public func ratingControlIconStyle<S: ShapeStyle>(_ style: S) -> some View {
        self
            .environment(\.ratingControlEmptyIconStyle, AnyShapeStyleBackport.shapeStyle(style))
            .environment(\.ratingControlFilledIconStyle, AnyShapeStyleBackport.shapeStyle(style))
    }
    
    /// Sets all icons in a ``RatingControl/RatingControl`` to use a given color.
    ///
    /// The default value is [`HierarchicalShapeStyle.primary`](https://developer.apple.com/documentation/swiftui/hierarchicalshapestyle/primary), if available (iOS 15+, etc.). Otherwise, it's [`Color.primary`](https://developer.apple.com/documentation/swiftui/color/primary).
    @available(iOS, introduced: 13.0, deprecated: 17.0, renamed: "ratingControlEmptyIconStyle(_:)")
    @available(macOS, introduced: 10.15, deprecated: 14.0, renamed: "ratingControlEmptyIconStyle(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 17.0, renamed: "ratingControlEmptyIconStyle(_:)")
    @available(watchOS, introduced: 6.0, deprecated: 10.0, renamed: "ratingControlEmptyIconStyle(_:)")
    @available(visionOS, introduced: 1.0, deprecated: 1.0, renamed: "ratingControlEmptyIconStyle(_:)")
    @ViewBuilder
    public func ratingControlIconColor(_ color: Color) -> some View {
        self
            .environment(\.ratingControlEmptyIconStyle, AnyShapeStyleBackport.color(color))
            .environment(\.ratingControlFilledIconStyle, AnyShapeStyleBackport.color(color))
    }
}

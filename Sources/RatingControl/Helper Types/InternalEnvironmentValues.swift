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

// MARK: EmptyIconColor

private struct RatingControlEmptyIconColorEnvironmentKey: EnvironmentKey {
    static let defaultValue: Color = .primary
}

extension EnvironmentValues {
    internal var ratingControlEmptyIconColor: Color {
        get { self[RatingControlEmptyIconColorEnvironmentKey.self] }
        set { self[RatingControlEmptyIconColorEnvironmentKey.self] = newValue }
    }
}

extension View {
    /// This sets the foreground color for empty icons in a ``RatingControl/RatingControl``.
    ///
    /// The default value is [`primary`](https://developer.apple.com/documentation/swiftui/color/primary).
    @ViewBuilder
    public func ratingControlEmptyIconColor(_ color: Color) -> some View {
        self.environment(\.ratingControlEmptyIconColor, color)
    }
}

// MARK: FilledIconColor

private struct RatingControlFilledIconColorEnvironmentKey: EnvironmentKey {
    static let defaultValue: Color = .primary
}

extension EnvironmentValues {
    internal var ratingControlFilledIconColor: Color {
        get { self[RatingControlFilledIconColorEnvironmentKey.self] }
        set { self[RatingControlFilledIconColorEnvironmentKey.self] = newValue }
    }
}

extension View {
    /// This sets the foreground color for filled icons in a ``RatingControl/RatingControl``.
    ///
    /// The default value is [`primary`](https://developer.apple.com/documentation/swiftui/color/primary).
    @ViewBuilder
    public func ratingControlFilledIconColor(_ color: Color) -> some View {
        self.environment(\.ratingControlFilledIconColor, color)
    }
}


//
//  RatingControl+Inits.swift
//  
//
//  Created by Edon Valdman on 12/28/23.
//

import SwiftUI

extension RatingControl where EmptyIcon == Image, FilledIcon == Image {
    /// Creates a `RatingControl` with a system symbol image as the empty icon and another as the filled icon.
    /// - Parameters:
    ///   - rating: The binding to a value you provide.
    ///   - axis: The axis on which to lay out the control.
    ///   - maximumRating: The maximum possible value. This is how many icons will be laid out.
    ///   - emptySystemImageName: The name of the system symbol image to use for every number increment past the current `rating` value, used to show the possible range of values.
    ///   - filledSystemImageName: The name of the system symbol image to use for every number increment up to the current `rating` value, used to show the current value.
    @available(iOS 13, macOS 11, macCatalyst 13, tvOS 13.0, watchOS 6, visionOS 1, *)
    init<V: BinaryFloatingPoint>(
        _ rating: Binding<V>,
        axis: Axis = .horizontal,
        maximumRating: V = 5,
        emptySystemImageName: String,
        filledSystemImageName: String
    ) {
        self.init(rating, axis: axis, maximumRating: maximumRating) {
            Image(systemName: emptySystemImageName)
        } filledIcon: {
            Image(systemName: filledSystemImageName)
        }
    }
    
    /// Creates a `RatingControl` with an image resource as the empty icon and another as the filled icon.
    /// - Parameters:
    ///   - rating: The binding to a value you provide.
    ///   - axis: The axis on which to lay out the control.
    ///   - maximumRating: The maximum possible value. This is how many icons will be laid out.
    ///   - emptyImageName: The name of the image resource to use for every number increment past the current `rating` value, used to show the possible range of values.
    ///   - filledImageName: The name of the image resource to use for every number increment up to the current `rating` value, used to show the current value.
    @available(iOS 13, macOS 10.15, macCatalyst 13, tvOS 13.0, watchOS 6, visionOS 1, *)
    init<V: BinaryFloatingPoint>(
        _ rating: Binding<V>,
        axis: Axis = .horizontal,
        maximumRating: V = 5,
        emptyImageName: String,
        filledImageName: String
    ) {
        self.init(rating, axis: axis, maximumRating: maximumRating) {
            Image(emptyImageName)
        } filledIcon: {
            Image(filledImageName)
        }
    }
    
    /// Creates a `RatingControl` with an image resource as the empty icon and a system symbol image as the filled icon.
    /// - Parameters:
    ///   - rating: The binding to a value you provide.
    ///   - axis: The axis on which to lay out the control.
    ///   - maximumRating: The maximum possible value. This is how many icons will be laid out.
    ///   - emptyImageName: The name of the image resource to use for every number increment past the current `rating` value, used to show the possible range of values.
    ///   - filledSystemImageName: The name of the system symbol image to use for every number increment up to the current `rating` value, used to show the current value.
    @available(iOS 13, macOS 11, macCatalyst 13, tvOS 13.0, watchOS 6, visionOS 1, *)
    init<V: BinaryFloatingPoint>(
        _ rating: Binding<V>,
        axis: Axis = .horizontal,
        maximumRating: V = 5,
        emptyImageName: String,
        filledSystemImageName: String
    ) {
        self.init(rating, axis: axis, maximumRating: maximumRating) {
            Image(emptyImageName)
        } filledIcon: {
            Image(systemName: filledSystemImageName)
        }
    }
    
    /// Creates a `RatingControl` with a system symbol image as the empty icon and an image resource as the filled icon.
    /// - Parameters:
    ///   - rating: The binding to a value you provide.
    ///   - axis: The axis on which to lay out the control.
    ///   - maximumRating: The maximum possible value. This is how many icons will be laid out.
    ///   - emptySystemImageName: The name of the system symbol image to use for every number increment past the current `rating` value, used to show the possible range of values.
    ///   - filledImageName: The name of the image resource to use for every number increment up to the current `rating` value, used to show the current value.
    @available(iOS 13, macOS 11, macCatalyst 13, tvOS 13.0, watchOS 6, visionOS 1, *)
    init<V: BinaryFloatingPoint>(
        _ rating: Binding<V>,
        axis: Axis = .horizontal,
        maximumRating: V = 5,
        emptySystemImageName: String,
        filledImageName: String
    ) {
        self.init(rating, axis: axis, maximumRating: maximumRating) {
            Image(systemName: emptySystemImageName)
        } filledIcon: {
            Image(filledImageName)
        }
    }
}

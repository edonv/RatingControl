//
//  RatingControl+Inits.swift
//  
//
//  Created by Edon Valdman on 12/28/23.
//

import SwiftUI

extension RatingControl where Empty == Image, Selected == Image {
    @available(iOS 13, macOS 11, macCatalyst 13, tvOS 13.0, watchOS 6, visionOS 1, *)
    init(
        _ rating: Binding<Int>,
        axis: Axis = .horizontal,
        maximumRating: Int = 5,
        emptySystemImageName: String,
        selectedSystemImageName: String
    ) {
        self.init(rating, axis: axis, maximumRating: maximumRating) {
            Image(systemName: emptySystemImageName)
        } selectedLabel: {
            Image(systemName: selectedSystemImageName)
        }
    }
    
    @available(iOS 13, macOS 10.15, macCatalyst 13, tvOS 13.0, watchOS 6, visionOS 1, *)
    init(
        _ rating: Binding<Int>,
        axis: Axis = .horizontal,
        maximumRating: Int = 5,
        emptyImageName: String,
        selectedImageName: String
    ) {
        self.init(rating, axis: axis, maximumRating: maximumRating) {
            Image(emptyImageName)
        } selectedLabel: {
            Image(selectedImageName)
        }
    }
    
    @available(iOS 13, macOS 11, macCatalyst 13, tvOS 13.0, watchOS 6, visionOS 1, *)
    init(
        _ rating: Binding<Int>,
        axis: Axis = .horizontal,
        maximumRating: Int = 5,
        emptyImageName: String,
        selectedSystemImageName: String
    ) {
        self.init(rating, axis: axis, maximumRating: maximumRating) {
            Image(emptyImageName)
        } selectedLabel: {
            Image(systemName: selectedSystemImageName)
        }
    }
    
    @available(iOS 13, macOS 11, macCatalyst 13, tvOS 13.0, watchOS 6, visionOS 1, *)
    init(
        _ rating: Binding<Int>,
        axis: Axis = .horizontal,
        maximumRating: Int = 5,
        emptySystemImageName: String,
        selectedImageName: String
    ) {
        self.init(rating, axis: axis, maximumRating: maximumRating) {
            Image(systemName: emptySystemImageName)
        } selectedLabel: {
            Image(selectedImageName)
        }
    }
}

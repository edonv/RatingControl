//
//  BackportShapeStyle.swift
//
//
//  Created by Edon Valdman on 12/29/23.
//

import SwiftUI

internal enum AnyShapeStyleBackport {
    case shapeStyle(any ShapeStyle)
    case color(Color)
    
    @available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15, watchOS 8.0, visionOS 1.0, *)
    var asShapeStyle: AnyShapeStyle {
        switch self {
        case .shapeStyle(let shapeStyle):
            AnyShapeStyle(shapeStyle)
        case .color(let color):
            AnyShapeStyle(color)
        }
    }
    
    var asColor: Color? {
        switch self {
        case .shapeStyle(let shapeStyle):
            if let color = shapeStyle as? Color {
                color
            } else {
                nil
            }
        case .color(let color):
            color
        }
    }
    
    static var primary: Self {
        if #available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15, watchOS 8.0, visionOS 1.0, *) {
            .shapeStyle(HierarchicalShapeStyle.primary)
        } else {
            .color(Color.primary)
        }
    }
}

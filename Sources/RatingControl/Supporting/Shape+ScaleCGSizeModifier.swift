//
//  Shape+ScaleCGSizeModifier.swift
//
//
//  Created by Edon Valdman on 1/1/24.
//

import SwiftUI

extension Shape {
    func scale(
        _ scale: CGSize,
        anchor: UnitPoint = .center
    ) -> ScaledShape<Self> {
        self.scale(x: scale.width, y: scale.height, anchor: anchor)
    }
}

//
//  Number+RoundToNearest.swift
//
//
//  Created by Edon Valdman on 1/1/24.
//

import Foundation

extension FloatingPoint {
    func rounded(upToMultiple multiple: Self) -> Self {
        return (self / multiple).rounded(.up) * multiple
    }
}

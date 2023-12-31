//
//  Float+IsWholeNumber.swift
//
//
//  Created by Edon Valdman on 12/31/23.
//

import Foundation

extension FloatingPoint {
    var isWholeNumber: Bool {
        self.truncatingRemainder(dividingBy: 1) == 0
    }
}

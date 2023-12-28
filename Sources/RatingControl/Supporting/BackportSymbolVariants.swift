//
//  BackportSymbolVariants.swift
//  
//
//  Created by Edon Valdman on 12/28/23.
//

import SwiftUI

internal struct BackportSymbolVariants: Hashable, Sendable, RawRepresentable/*, CaseIterable*/ {
    // heart.slash.circle.fill
    private enum Values: String, Equatable, Comparable, CaseIterable {
        case none
        case slash
        case circle
        case fill
        case square
        case rectangle
        
        var sortOrder: Int {
            switch self {
            case .none:
                0
            case .slash:
                1
            case .circle:
                2
            case .fill:
                3
            case .square:
                4
            case .rectangle:
                5
            }
        }
        
        @available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *)
        var symbolVariants: SymbolVariants {
            switch self {
            case .none:
                return .none
            case .slash:
                return .slash
            case .circle:
                return .circle
            case .fill:
                return .fill
            case .square:
                return .square
            case .rectangle:
                return .rectangle
            }
        }
        
//        @available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *)
//        static func from(_ variant: SymbolVariants) -> Self {
//
//        }
        
        static func < (lhs: BackportSymbolVariants.Values, rhs: BackportSymbolVariants.Values) -> Bool {
            lhs.sortOrder < rhs.sortOrder
        }
    }
    
//    internal static let allCases: [BackportSymbolVariants] = [.none, .circle, .square, .rectangle, .fill, .slash]
    
    internal var rawValue: String {
        guard !values.contains(.none) else { return "" }
        return "." + values
            .sorted()
            .map(\.rawValue)
            .joined(separator: ".")
    }
    
    private var values: Set<Values>
    
    internal init?(rawValue: String) {
        guard !rawValue.isEmpty else {
            self = .none
            return
        }
        
        let splitString = rawValue
            .trimmingCharacters(in: CharacterSet(["."]))
            .split(separator: ".")
        
        let mapped = splitString.compactMap { Values(rawValue: String($0)) }
        guard mapped.count == splitString.count else { return nil }
        
        self.values = .init(mapped)
    }
    
    private init<S: Sequence>(private rawValue: S) where S.Element == Values {
        self.values = .init(rawValue)
    }
    
    @available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *)
    internal init(variant: SymbolVariants) {
        guard variant != .none else {
            self = .none
            return
        }
        
        self.values = [Values.circle, .square, .rectangle, .fill, .slash].reduce(into: []) { partialResult, option in
            guard variant.contains(option.symbolVariants) else { return }
            partialResult.insert(option)
        }
    }
    
    // MARK: - Values
    
    /// No variant for a symbol.
    internal static let none: BackportSymbolVariants = .init(private: [])

    /// A variant that encapsulates the symbol in a circle.
    internal static let circle: BackportSymbolVariants = .init(private: [.circle])

    /// A variant that encapsulates the symbol in a square.
    internal static let square: BackportSymbolVariants = .init(private: [.square])

    /// A variant that encapsulates the symbol in a rectangle.
    internal static let rectangle: BackportSymbolVariants = .init(private: [.rectangle])

    /// A variant that fills the symbol.
    internal static let fill: BackportSymbolVariants = .init(private: [.fill])

    /// A variant that draws a slash through the symbol.
    internal static let slash: BackportSymbolVariants = .init(private: [.slash])
    
    internal func contains(_ other: BackportSymbolVariants) -> Bool {
        values.isSuperset(of: other.values)
    }
    
    // MARK: - Modifiers
    
    /// A version of the variant that’s encapsulated in a circle.
    internal var circle: BackportSymbolVariants {
        .init(private: self.values.union(CollectionOfOne(.circle)))
    }
    
    /// A version of the variant that’s encapsulated in a square.
    internal var square: BackportSymbolVariants {
        .init(private: self.values.union(CollectionOfOne(.square)))
    }
    
    /// A version of the variant that’s encapsulated in a rectangle.
    internal var rectangle: BackportSymbolVariants {
        .init(private: self.values.union(CollectionOfOne(.rectangle)))
    }
    
    /// A filled version of the variant.
    internal var fill: BackportSymbolVariants {
        .init(private: self.values.union(CollectionOfOne(.fill)))
    }
    
    /// A slashed version of the variant.
    internal var slash: BackportSymbolVariants {
        .init(private: self.values.union(CollectionOfOne(.slash)))
    }
    
    // MARK: Bridging
    
    @available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *)
    internal var symbolVariants: SymbolVariants {
        values.reduce(into: .none) { partial, value in
            partial = switch value {
            case .none:
                partial
            case .slash:
                partial.slash
            case .circle:
                partial.circle
            case .fill:
                partial.fill
            case .square:
                partial.square
            case .rectangle:
                partial.rectangle
            }
        }
    }
}

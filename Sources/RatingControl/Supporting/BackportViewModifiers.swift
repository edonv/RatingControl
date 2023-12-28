//
//  BackportViewModifiers.swift
//
//
//  Created by Edon Valdman on 12/28/23.
//

import SwiftUI
import Combine

extension View {
    @ViewBuilder
    func backgroundBackport<V>(
        alignment: Alignment = .center,
        @ViewBuilder content: () -> V
    ) -> some View where V: View {
        if #available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15, watchOS 8.0, visionOS 1.0, *) {
            background(alignment: alignment, content: content)
        } else {
            background(content(), alignment: alignment)
        }
    }
    
    @ViewBuilder
    func overlayBackport<V>(
        alignment: Alignment = .center,
        @ViewBuilder content: () -> V
    ) -> some View where V: View {
        if #available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15, watchOS 8.0, visionOS 1.0, *) {
            overlay(alignment: alignment, content: content)
        } else {
            overlay(content(), alignment: alignment)
        }
    }
    
    @ViewBuilder
    func onChangeBackport<Value: Equatable>(of value: Value, perform action: @escaping (Value) -> Void) -> some View {
        self.onReceive(Just(value).removeDuplicates()) { newValue in
            action(newValue)
        }
    }
}

//
//  BindingExtenstions.swift
//  KISS Views
//

import SwiftUI

public extension Binding {

    /// A convenience initializer allowing to create a binding to an optional value, with an initial value.
    ///
    /// - Parameters:
    ///   - currentValue: a binding to an optional, current value.
    ///   - initialValue: an initial value. Used if a current value is nil.
    init(currentValue: Binding<Value?>, initialValue: Value) {
        self.init(
            get: {
                currentValue.wrappedValue ?? initialValue
            },
            set: {
                currentValue.wrappedValue = $0
            }
        )
    }
}

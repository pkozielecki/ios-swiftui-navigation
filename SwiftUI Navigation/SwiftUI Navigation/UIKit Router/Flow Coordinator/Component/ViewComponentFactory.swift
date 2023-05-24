//
//  ViewComponentFactory.swift
//  KISS Views
//

import Foundation

/// An abstraction describing a factory producing view components.
protocol ViewComponentFactory {

    /// A method that produces a view components for a given route.
    ///
    /// - Parameters:
    ///   - route: a route.
    ///   - withData: an additional data.
    /// - Returns: a view components list.
    func makeViewComponents(forRoute route: any Route, withData: AnyHashable?) -> [ViewComponent]
}

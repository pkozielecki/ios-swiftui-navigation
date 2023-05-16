//
//  ViewComponentFactory.swift
//  KISS Views
//

import Foundation

/// An abstraction describing a factory producing view components.
protocol ViewComponentFactory {

    /// A method that produces a view component for a given route.
    ///
    /// - Parameters:
    ///   - route: a route.
    ///   - withData: an additional data.
    /// - Returns: a view component.
    func makeViewComponent(forRoute route: any Route, withData: AnyHashable?) -> ViewComponent
}

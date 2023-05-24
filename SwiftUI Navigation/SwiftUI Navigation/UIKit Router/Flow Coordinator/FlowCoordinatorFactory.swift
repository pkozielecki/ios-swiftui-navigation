//
//  FlowCoordinatorFactory.swift
//  KISS Views
//

import Foundation

/// An abstraction describing a factory producing flow coordinators.
protocol FlowCoordinatorFactory {

    /// A method that produces a flow coordinator for a given route.
    ///
    /// - Parameters:
    ///   - route: a route.
    ///   - navigator: a navigator.
    ///   - withData: an additional data.
    /// - Returns: a flow coordinator.
    func makeFlowCoordinator(forRoute route: any Route, navigator: Navigator, withData: AnyHashable?) -> FlowCoordinator
}

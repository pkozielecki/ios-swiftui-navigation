//
//  Route.swift
//  KISS Views
//

import UIKit

/// A navigation route that can be used to navigate to a specific screen or flow.
protocol Route: Equatable {

    /// The name of the route.
    var name: String { get }

    /// Whether the route is a separate flow.
    var isFlow: Bool { get }

    /// Whether the route is to be presented as popup.
    var isPopup: Bool { get }
}

/// An empty implementation of the `Route` protocol.
struct EmptyRoute: Route {

    /// - SeeAlso: `Route.name`
    var name: String {
        ""
    }

    /// - SeeAlso: `Route.isFlow`
    var isFlow: Bool {
        false
    }

    /// - SeeAlso: `Route.isPopup`
    var isPopup: Bool {
        false
    }
}

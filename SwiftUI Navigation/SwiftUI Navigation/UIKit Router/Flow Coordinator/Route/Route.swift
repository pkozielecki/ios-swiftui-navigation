//
//  Route.swift
//  KISS Views
//

import UIKit

/// An enum describing a popup presentation style.
enum PopupPresentationStyle: Equatable {
    /// No popup presentation.
    case none

    /// A full screen popup presentation.
    case fullScreen

    /// A modal popup presentation.
    case modal
}

extension PopupPresentationStyle {

    /// A convenience property that returns a UIKit modal presentation style.
    var modalPresentationStyle: UIModalPresentationStyle {
        switch self {
        case .none:
            return .none
        case .fullScreen:
            return .fullScreen
        case .modal:
            return .pageSheet
        }
    }
}

/// A navigation route that can be used to navigate to a specific screen or flow.
protocol Route: Equatable {

    /// The name of the route.
    var name: String { get }

    /// Whether the route is a separate flow.
    var isFlow: Bool { get }

    /// A route popup presentation mode.
    var popupPresentationStyle: PopupPresentationStyle { get }
}

extension Route {

    /// A convenience property that returns whether the route is a popup.
    var isPopup: Bool {
        switch popupPresentationStyle {
        case .none:
            return false
        case .fullScreen, .modal:
            return true
        }
    }

    /// A convenience method that returns whether the route matches the given route.
    func matches(_ route: any Route) -> Bool {
        name == route.name && isFlow == route.isFlow && popupPresentationStyle == route.popupPresentationStyle
    }
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

    /// - SeeAlso: `Route.popupPresentationStyle`
    var popupPresentationStyle: PopupPresentationStyle {
        .none
    }
}

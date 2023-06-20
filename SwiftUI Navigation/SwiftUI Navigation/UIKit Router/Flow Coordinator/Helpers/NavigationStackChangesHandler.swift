//
//  NavigationStackChangesHandler.swift
//  KISS Views
//

import UIKit

/// An object that handles navigation stack changes - a delegate for UINavigationController.
final class NavigationStackChangesHandler: NSObject, UINavigationControllerDelegate {
    private let onRouteShown: ((any Route) -> Void)?

    /// A default initializer for NavigationStackChangesHandler.
    ///
    /// - Parameter onRouteShown: a callback to be executed on delegate call.
    init(onRouteShown: ((any Route) -> Void)?) {
        self.onRouteShown = onRouteShown
    }

    /// - SeeAlso: UINavigationControllerDelegate.navigationController(_:didShow:animated:)
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        onRouteShown?(viewController.route)
    }
}

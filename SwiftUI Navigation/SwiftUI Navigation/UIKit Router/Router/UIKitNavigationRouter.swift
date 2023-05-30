//
//  UIKitNavigationRouter.swift
//  KISS Views
//

import Foundation

// MARK: - UIKitNavigationRouter

/// An abstraction describing a UIKit navigation router.
protocol UIKitNavigationRouter: AnyObject {

    /// Shows a route in the flow.
    ///
    /// - Parameters:
    ///   - route: a route to show.
    ///   - withData: an optional data necessary to create a view.
    func show(route: any Route, withData: AnyHashable?)

    /// Switches to a route.
    func `switch`(toRoute route: any Route, withData: AnyHashable?)

    /// Navigates back one view.
    ///
    /// - Parameter animated: a flag indicating whether the navigation should be animated.
    func navigateBack(animated: Bool)

    /// Stops the router.
    func stop()

    /// Navigates back to the root view of the flow.
    ///
    /// - Parameter animated: a flag indicating whether the navigation should be animated.
    func navigateBackToRoot(animated: Bool)

    /// Navigates back to an already shown route.
    ///
    /// - Parameters:
    ///   - route: a route to navigate back to.
    ///   - animated: a flag indicating whether the navigation should be animated.
    func navigateBack(toRoute route: any Route, animated: Bool)

    /// Starts the initial flow.
    ///
    /// - Parameters:
    ///  - initialFlow: an initial flow to start.
    /// - animated: a flag indicating whether the navigation should be animated.
    func start(initialFlow: FlowCoordinator, animated: Bool)
}

// MARK: - DefaultUIKitNavigationRouter

/// A default implementation of UIKitNavigationRouter.
final class DefaultUIKitNavigationRouter: UIKitNavigationRouter {
    private var initialFlow: FlowCoordinator?

    /// - SeeAlso: UIKitNavigationRouter.startInitialFlow(initialFlow:animated:)
    func start(initialFlow: FlowCoordinator, animated: Bool) {
        self.initialFlow = initialFlow
        initialFlow.start(animated: animated)
    }

    /// - SeeAlso: UIKitNavigationRouter.show(route:withData:)
    func show(route: any Route, withData: AnyHashable?) {
        if currentFlow?.canShow(route: route) == true {
            currentFlow?.show(route: route, withData: withData)
        }
    }

    /// - SeeAlso: UIKitNavigationRouter.switch(toRoute:withData:)
    func `switch`(toRoute route: any Route, withData: AnyHashable?) {
        currentFlow?.switch(toRoute: route, withData: withData)
    }

    /// - SeeAlso: UIKitNavigationRouter.navigateBack(animated:)
    func navigateBack(animated: Bool) {
        currentFlow?.navigateBack(animated: animated)
    }

    /// - SeeAlso: UIKitNavigationRouter.navigateBackToRoot(animated:)
    func navigateBackToRoot(animated: Bool) {
        currentFlow?.navigateBackToRoot(animated: animated)
    }

    /// - SeeAlso: UIKitNavigationRouter.navigateBack(toRoute:animated:)
    func navigateBack(toRoute route: any Route, animated: Bool) {
        currentFlow?.navigateBack(toRoute: route, animated: animated)
    }

    /// - SeeAlso: UIKitNavigationRouter.stop()
    func stop() {
        currentFlow?.stop()
    }
}

// MARK: - Helpers

extension DefaultUIKitNavigationRouter {

    /// Returns the current flow.
    var currentFlow: FlowCoordinator? {
        getCurrentFlow(base: initialFlow)
    }
}

// MARK: - Private

private extension DefaultUIKitNavigationRouter {

    func getCurrentFlow(base: FlowCoordinator?) -> FlowCoordinator? {
        if let child = base?.child {
            return getCurrentFlow(base: child)
        }
        return base
    }
}

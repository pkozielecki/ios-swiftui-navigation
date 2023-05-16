//
//  UIKitNavigationRouter.swift
//  KISS Views
//

import Foundation

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
    /// - Parameter dependencyProvider: a dependency provider.
    /// - Parameter animated: a flag indicating whether the navigation should be animated.
    func startInitialFlow(dependencyProvider: DependencyProvider, animated: Bool)
}

/// A default implementation of UIKitNavigationRouter.
final class DefaultUIKitNavigationRouter: UIKitNavigationRouter {
    private let navigator: Navigator
    private var dependencyProvider: DependencyProvider?
    private var currentFlow: FlowCoordinator?

    /// A default initializer for DefaultUIKitNavigationRouter.
    ///
    /// - Parameter navigator: a navigator.
    init(
        navigator: Navigator
    ) {
        self.navigator = navigator
    }

    /// - SeeAlso: UIKitNavigationRouter.startInitialFlow(dependencyProvider:animated:)
    func startInitialFlow(dependencyProvider: DependencyProvider, animated: Bool) {
        self.dependencyProvider = dependencyProvider
        currentFlow = MainAppFlowCoordinator(navigator: navigator, dependencyProvider: dependencyProvider)
        currentFlow?.start(animated: animated)
    }

    /// - SeeAlso: UIKitNavigationRouter.show(route:withData:)
    func show(route: any Route, withData: AnyHashable?) {
        if currentFlow?.canShow(route: route) == true {
            currentFlow?.show(route: route, withData: withData)
        } else {
            currentFlow?.parent?.show(route: route, withData: withData)
        }
    }

    /// - SeeAlso: UIKitNavigationRouter.switch(toRoute:withData:)
    func `switch`(toRoute route: any Route, withData: AnyHashable?) {
        currentFlow?.parent?.switch(toRoute: route, withData: withData)
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
        currentFlow = nil
    }
}

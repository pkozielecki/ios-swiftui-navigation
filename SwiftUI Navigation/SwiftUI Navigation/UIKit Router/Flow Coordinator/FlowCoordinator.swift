//
//  FlowCoordinator.swift
//  KISS Views
//

import ObjectiveC
import UIKit

/// An associated object key for a Flow Coordinator route.
private var FlowCoordinatorRouteKey: UInt8 = 234

/// An abstraction describing a navigation flow.
protocol FlowCoordinator: ViewComponent, ViewComponentFactory, FlowCoordinatorFactory {

    /// A navigator the flow operates on.
    var navigator: Navigator { get }

    /// A parent flow coordinator.
    var parent: FlowCoordinator? { get }

    /// A starts the flow.
    ///
    /// - Parameter animated: a flag indicating whether the flow should be started with animation.
    func start(animated: Bool)

    /// Stops the flow.
    func stop()

    /// Shows a route in the flow.
    ///
    /// - Parameters:
    ///   - route: a route to show.
    ///   - withData: an optional data necessary to create a view.
    func show(route: any Route, withData: AnyHashable?)

    /// Checks whether a route can be shown in the flow.
    ///
    /// - Parameter route: a route to check.
    /// - Returns: a flag indicating whether a route can be shown in the flow.
    func canShow(route: any Route) -> Bool

    /// Switches to a route.
    func `switch`(toRoute route: any Route, withData: AnyHashable?)

    /// Navigates back one view.
    ///
    /// - Parameter animated: a flag indicating whether the navigation should be animated.
    func navigateBack(animated: Bool)

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
}

// MARK: - Default implementation

extension FlowCoordinator {

    var viewController: UIViewController {
        navigator.navigationStack
    }

    var route: any Route {
        get {
            objc_getAssociatedObject(self, &FlowCoordinatorRouteKey) as? any Route ?? EmptyRoute()
        }
        set {
            objc_setAssociatedObject(self, &FlowCoordinatorRouteKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func show(route: any Route, withData: AnyHashable?) {
        guard canShow(route: route) else {
            return
        }

        if route.isFlow {
            let flowCoordinator = makeFlowCoordinator(forRoute: route, withData: withData)
            flowCoordinator.route = route
            // TODO: If route starts as a popup, make sure to create new navigation controller and use it as nav base!
            flowCoordinator.start()
        } else {
            let viewComponent = makeViewComponent(forRoute: route, withData: withData)
            viewComponent.route = route
            if route.isPopup {
                navigator.present(viewComponent.viewController, animated: true, completion: nil)
            } else {
                navigator.pushViewController(viewComponent.viewController, animated: true)
            }
        }
    }

    func `switch`(toRoute route: any Route, withData: AnyHashable?) {
        // TODO: Implement switching between routes.
        // TODO: pass the request down the parent flow if needed.
    }

    func start() {
        start(animated: true)
    }

    func show(route: any Route) {
        show(route: route, withData: nil)
    }

    func `switch`(toRoute route: any Route) {
        `switch`(toRoute: route, withData: nil)
    }

    func navigateBack() {
        navigateBack(animated: true)
    }

    func navigateBackToRoot() {
        navigateBackToRoot(animated: true)
    }

    func navigateBack(toRoute route: any Route) {
        navigateBack(toRoute: route, animated: true)
    }
}
